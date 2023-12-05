//
//  MainItomCell.swift
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
    
    func setup(item: MainDataItem) {
        titleLabel.text = item.title
        deadlineLabel.text = item.deadlineString
        
        deadlineLabel.textColor = Date() > item.deadlineDate ? UIColor.Color.red : UIColor.Color.black
        
        radioButton.setImage(UIImage.Main.radiobuttonDefault, for: .normal)
        if item.isCompleted {
            radioButton.setImage(UIImage.Main.radiobuttonCheckmark, for: .normal)
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var radioButton: UIButton!
    @IBOutlet private var deadlineLabel: UILabel!
    
    @IBAction private func didTapRadioButton() {
        delegate?.didTapRadioButton(on: self)
    }
}
