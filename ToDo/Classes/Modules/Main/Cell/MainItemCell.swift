//
//  MainItomCell.swift
//  ToDo
//
//  Created by Светлана Полоротова on 14.11.2023.
//

import UIKit

final class MainItemCell: UICollectionViewCell {
    static let reuseID = String(describing: MainItemCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColor()
        setupRadioButtonView()
        setupAppearance()
    }
    
    override var isSelected: Bool {
        didSet {
            updateColor()
        }
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
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var radioButtonView: UIView!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var checkmarkImageView: UIImageView!
    @IBOutlet private var deadlineLabel: UILabel!
    
    private func updateColor() {
        radioButtonView.backgroundColor = isSelected ? UIColor.Color.primary : UIColor.Color.ItemCell.radiobutton
        checkmarkImageView.isHidden = !isSelected
    }
    
    private func setupRadioButtonView() {
        radioButtonView.layer.cornerRadius = radioButtonView.frame.height / 2
        radioButtonView.clipsToBounds = true
    }
    
    private func setupAppearance() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor.Color.black
        deadlineLabel.font = .systemFont(ofSize: 14)
        deadlineLabel.numberOfLines = 2
        backgroundColor = UIColor.Color.ItemCell.background
    }
}
