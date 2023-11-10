//
//  PrimaryButton.swift
//  ToDo
//
//  Created by Светлана Полоротова on 09.11.2023.
//

import UIKit

final class PrimaryButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        style = Style(
            cornerRadius: 8,
            insets: 32,
            bgColor: .Color.primary,
            heightbgColor: .Color.primary.withAlphaComponent(0.5),
            titleColor: .Color.white,
            heightedTitleColor: .Color.white
        )
    }
}
