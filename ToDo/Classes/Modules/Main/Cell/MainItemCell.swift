//
//  MainItemCell.swift
//  ToDo
//
//  Created by Светлана Полоротова on 14.11.2023.
//

import UIKit

protocol MainItemCellDelegate: AnyObject {
    func didTapRadioButton(on id: String)
}

final class MainItemCell: UICollectionViewCell {
    struct Data {
        let id: String
        let title: String
        let deadline: Date
        let isCompleted: Bool
    }

    weak var delegate: MainItemCellDelegate?
    static let reuseID = String(describing: MainItemCell.self)
    private var itemId: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        radioButton.setImage(UIImage.checkmark, for: .highlighted)

        layer.cornerRadius = 16
        layer.masksToBounds = true

        radioButton.layer.cornerRadius = radioButton.frame.height / 2
        radioButton.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor.Color.black
        deadlineLabel.font = .systemFont(ofSize: 14)
        deadlineLabel.numberOfLines = 2
        backgroundColor = UIColor.Color.ItemCell.background
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }

    private let currentDate = Date()

    func setup(data: Data) {
        itemId = data.id
        titleLabel.text = data.title
        deadlineLabel.text = "\(L10n.Main.deadline) \(DateFormatter.dateFormate.string(from: data.deadline))"
        deadlineLabel.textColor = currentDate > data.deadline ? UIColor.Color.red : UIColor.Color.black

        if data.isCompleted {
            radioButton.setImage(UIImage.Main.radiobuttonCheckmark, for: .normal)
        } else {
            radioButton.setImage(UIImage.Main.radiobuttonDefault, for: .normal)
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var radioButton: LargeButton!
    @IBOutlet private var deadlineLabel: UILabel!

    @IBAction private func didTapRadioButton() {
        if let itemId = itemId {
            delegate?.didTapRadioButton(on: itemId)
        }
    }
}

extension MainItemCell.Data {
    init(from item: TodoItemResponseBody) {
        id = item.id
        title = item.title
        deadline = item.date
        isCompleted = item.isCompleted
    }
}
