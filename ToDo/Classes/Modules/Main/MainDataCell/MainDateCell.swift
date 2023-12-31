//
//  MainDateCell.swift
//  ToDo
//
//  Created by Светлана Полоротова on 07.12.2023.
//

import UIKit

final class MainDateCell: UICollectionViewCell {
    static let reuseID = String(describing: MainDateCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.Color.BackgroungAndSurfaces.surfaceSecondary
        contentView.layer.cornerRadius = 10
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.Color.primary : UIColor.Color.BackgroungAndSurfaces.surfaceSecondary
            titleLabel.textColor = isSelected ? UIColor.Color.white : UIColor.Color.black
        }
    }

    func setup(title: String) {
        titleLabel.text = title
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
