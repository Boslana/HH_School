//
//  DateFormatter.swift
//  ToDo
//
//  Created by Светлана Полоротова on 24.11.2023.
//

import UIKit

extension DateFormatter {
    static let dateFormate = {
        let formatter = DateFormatter()
        formatter.dateFormat = L10n.Main.dateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
