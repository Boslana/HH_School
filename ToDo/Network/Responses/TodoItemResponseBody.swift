//
//  TodoItemResponseBody.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.11.2023.
//

import Foundation

struct TodoItemResponseBody: Decodable {
    let id: String
    let title: String
    let description: String
    let date: Date
    var isCompleted: Bool
}
