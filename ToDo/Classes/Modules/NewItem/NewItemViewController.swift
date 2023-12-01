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
    func didSelect(_ vc: NewItemViewController, data: NewItemData)
}

final class NewItemViewController: ParentViewController {
    @IBOutlet private var whatToDoView: TextViewInput!
    @IBOutlet private var descriptionView: UIView!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var createButton: PrimaryButton!
    
    weak var delegate: NewItemViewControllerDelegate?
    
    var selectedItem: MainDataItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.NewItem.title
        deadlineLabel.text = L10n.NewItem.deadlineTitle
        createButton.setTitle(L10n.NewItem.createButton, for: .normal)
        
        addTapToHideKeyboardGesture()
        
        if let selectedItem {
            whatToDoView.set(text: selectedItem.title)
        }
    }
    
    @IBAction private func didTap() {
        delegate?.didSelect(self, data: NewItemData(title: "Приготовить ужин", description: "textView.text2", deadline: datePicker.date))
        navigationController?.popViewController(animated: true)
    }
}
