//
//  MainItemCell.swift
//  ToDo
//
//  Created by Светлана Полоротова on 14.11.2023.
//

import UIKit

protocol MainItemCellDelegate: AnyObject {
    func didTapRadioButton(on cell: MainItemCell)
}

final class MainItemCell: UICollectionViewCell {
    weak var delegate: MainItemCellDelegate?
    static let reuseID = String(describing: MainItemCell.self)

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

    func setup(item: TodoItemResponseBody) {
        titleLabel.text = item.title
        deadlineLabel.text = "\(L10n.Main.deadline) \(DateFormatter.dateFormate.string(from: item.date))"
        deadlineLabel.textColor = currentDate > item.date ? UIColor.Color.red : UIColor.Color.black

        if item.isCompleted {
            radioButton.setImage(UIImage.Main.radiobuttonCheckmark, for: .normal)
        } else {
            radioButton.setImage(UIImage.Main.radiobuttonDefault, for: .normal)
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var radioButton: LargeButton!
    @IBOutlet private var deadlineLabel: UILabel!

    @IBAction private func didTapRadioButton() {
        delegate?.didTapRadioButton(on: self)
    }
}
