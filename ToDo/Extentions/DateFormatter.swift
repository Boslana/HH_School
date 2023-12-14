//
//  DateFormatter.swift
//  ToDo
//
//  Created by Светлана Полоротова on 24.11.2023.
//

import UIKit

extension DateFormatter {
    static let customShortMonthSymbols = ["Янв", "Фев", "Мар", "Апр", "Мая", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]

    static let dateFormate = {
        let formatter = DateFormatter()
        formatter.dateFormat = L10n.Main.itemCellDateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    static let dMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.shortMonthSymbols = customShortMonthSymbols
        return formatter
    }()

    static let dMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.shortMonthSymbols = customShortMonthSymbols
        return formatter
    }()
}
