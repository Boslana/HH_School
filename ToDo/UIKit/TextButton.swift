//
//  TextButton.swift
//  ToDo
//
//  Created by Светлана Полоротова on 11.11.2023.
//

import UIKit

final class TextButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(mode: Mode.normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(mode: Mode.normal)
    }
    
    enum Mode {
        case normal
        case destructive
    }
    
    func setup(mode: Mode) {
        if mode == Mode.normal {
            style = Style(
                font: .systemFont(ofSize: 16, weight: .bold),
                insets: 32,
                height: 54,
                titleColor: .Color.black,
                highlightedTitleColor: .Color.black.withAlphaComponent(0.5)
            )
        } else if mode == Mode.destructive {
            style = Style(
                font: .systemFont(ofSize: 16, weight: .bold),
                insets: 32,
                height: 54,
                titleColor: .Color.red,
                highlightedTitleColor: .Color.red.withAlphaComponent(0.5)
            )
        }
    }
}
