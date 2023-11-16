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
    @IBOutlet private var whatToDoLable: UIView!
    @IBOutlet private var descriptionLabel: UIView!
    @IBOutlet private var deadline: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var creat: UIButton!
    
    weak var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Новая запись"
    }
    
    @IBAction private func didTap() {
        delegate?.didSelect(self, data: NewItemData(title: "textView.text", description: "textView.text2", deadline: datePicker.date))
        navigationController?.popViewController(animated: true)
    }
}
