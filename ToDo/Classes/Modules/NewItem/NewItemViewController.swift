//
//  NewItemViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 16.11.2023.
//

import Dip
import UIKit

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController, action: ItemAction, date: Date?)
}

enum ItemAction {
    case add
    case delete
}

final class NewItemViewController: ParentViewController {
    @Injected private var networkManager: ItemManager!

    weak var delegate: NewItemViewControllerDelegate?
    var selectedItem: TodoItemResponseBody?
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedDate {
            datePicker.date = selectedDate
        }

        setupInitialView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupDatePickerAppearance()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
    }

    @IBOutlet private var whatToDoView: TextViewInput!
    @IBOutlet private var descriptionView: TextViewInput!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePickerContainer: UIView!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!

    @IBOutlet private var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var keyboardButtonConstraint: NSLayoutConstraint!
    @IBOutlet private var keyboardScrollViewConstraint: NSLayoutConstraint!

    private func setupInitialView() {
        whatToDoView.setup(titleText: L10n.NewItem.whatToDoViewTitle)
        descriptionView.setup(titleText: L10n.NewItem.descriptionViewTitle)

        deadlineLabel.text = L10n.NewItem.deadlineTitle
        deadlineLabel.textColor = .Color.black
        deadlineLabel.font = UIFont.systemFont(ofSize: 14)

        datePicker.tintColor = .Color.datePicker
        datePicker.backgroundColor = .white
        datePicker.layer.masksToBounds = false

        if let selectedItem {
            navigationItem.title = L10n.EditItem.title
            let deleteButton = UIBarButtonItem(title: L10n.EditItem.deleteButton, style: .plain, target: self, action: #selector(didTapDeleteButton))
            navigationItem.rightBarButtonItem = deleteButton
            deleteButton.tintColor = UIColor.Color.error

            whatToDoView.set(text: selectedItem.title)
            descriptionView.set(text: selectedItem.description)
            datePicker.date = selectedItem.date

            createButton.isHidden = true

            keyboardButtonConstraint.isActive = false
            buttonBottomConstraint.isActive = false
            keyboardScrollViewConstraint.isActive = true
        } else {
            navigationItem.title = L10n.NewItem.title

            createButton.setTitle(L10n.NewItem.createButton, for: .normal)
            createButton.setup(mode: .large)
            createButton.isHidden = false

            keyboardScrollViewConstraint.isActive = false
            buttonBottomConstraint.isActive = true
            keyboardButtonConstraint.isActive = true
        }
        view.layoutIfNeeded()

        addTapToHideKeyboardGesture()
    }

    private func setupDatePickerAppearance() {
        datePickerContainer.layer.cornerRadius = 13
        datePickerContainer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        datePickerContainer.layer.shadowOpacity = 1
        datePickerContainer.layer.shadowRadius = 60
        datePickerContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        datePickerContainer.layer.shadowPath = UIBezierPath(rect: datePicker.bounds).cgPath
        datePickerContainer.layer.masksToBounds = false

        datePicker.layer.cornerRadius = 13
        datePicker.clipsToBounds = true
    }

    @IBAction private func didTapCreateButton() {
        var isValid = true

        if whatToDoView.textTextView?.isEmpty ?? true {
            whatToDoView.show(error: L10n.Validation.emptyTextField)
            isValid = false
        }

        if descriptionView.textTextView?.isEmpty ?? true {
            descriptionView.show(error: L10n.Validation.emptyTextField)
            isValid = false
        }

        if isValid {
            createButton.setLoading(true)
            Task {
                do {
                    _ = try await networkManager.createNewTodo(title: whatToDoView.textTextView ?? "", description: descriptionView.textTextView ?? "", date: datePicker.date)
                    delegate?.didSelect(self, action: .add, date: datePicker.date)
                    navigationController?.popViewController(animated: true)
                } catch {
                    createButton.setLoading(false)
                    DispatchQueue.main.async {
                        self.showSnackbar(message: error.localizedDescription)
                    }
                }
            }
        }
    }

    @objc
    private func didTapDeleteButton() {
        Task {
            do {
                _ = try await networkManager.deleteTodo(todoId: selectedItem?.id ?? "")
                delegate?.didSelect(self, action: .delete, date: nil)
                navigationController?.popViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbar(message: error.localizedDescription)
                }
            }
        }
    }
}
