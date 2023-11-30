//
//  NewItemViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 16.11.2023.
//

import UIKit

struct NewItemData {
    let title: String
    let description: String
    let deadline: Date
}

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController)
}

final class NewItemViewController: ParentViewController {
    weak var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupDatePickerAppearance()
    }
    
    @IBOutlet private var whatToDoView: TextViewInput!
    @IBOutlet private var descriptionView: TextViewInput!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePickerContainer: UIView!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!
    
    private func setupInitialView() {
        navigationItem.title = L10n.NewItem.title
        
        whatToDoView.setup(titleText: L10n.Main.whatToDoViewTitle)
        descriptionView.setup(titleText: L10n.Main.descriptionViewTitle)
        
        deadlineLabel.text = L10n.NewItem.deadlineTitle
        deadlineLabel.textColor = .Color.black
        deadlineLabel.font = UIFont.systemFont(ofSize: 14)
        
        createButton.setTitle(L10n.NewItem.createButton, for: .normal)
        createButton.setup(mode: .large)
        
        datePicker.tintColor = .Color.datePicker
        datePicker.backgroundColor = .white
        datePicker.layer.masksToBounds = false
        
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
        Task {
            do {
                _ = try await NetworkManager.shared.createNewTodo(title: whatToDoView.textTextView , description: descriptionView.textTextView, date: datePicker.date)
                delegate?.didSelect(self)
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(title: L10n.NetworkErrorDescription.alertTitle, massage: error.localizedDescription)
            }
        }
    }
}
