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
        setup(mode: Mode.large)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(mode: Mode.large)
    }
    
    enum Mode {
        case large
        case small
    }
    
    func setup(mode: Mode) {
        if mode == Mode.large {
            style = Style(
                cornerRadius: 8,
                insets: 32,
                bgColor: .Color.primary,
                heightbgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                heightedTitleColor: .Color.white
            )
        } else if mode == Mode.small {
            style = Style(
                cornerRadius: 8,
                insets: 22,
                height: 34,
                bgColor: .Color.primary,
                heightbgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                heightedTitleColor: .Color.white
            )
        }
    }
}
