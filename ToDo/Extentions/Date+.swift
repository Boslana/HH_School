//
//  Date+.swift
//  ToDo
//
//  Created by Светлана Полоротова on 07.12.2023.
//

import Foundation

extension Date {
    var withoutTimeStamp: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }
}
