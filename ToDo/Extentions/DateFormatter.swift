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
        formatter.dateFormat = L10n.Main.itemCellDateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    static let dMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
}
