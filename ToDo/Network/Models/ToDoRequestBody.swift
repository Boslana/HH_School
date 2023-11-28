//
//  postToDoRequestBody.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.11.2023.
//

import Foundation

struct NewTodoItemRequestBody: Encodable {
    let category: String
    let title: String
    let description: String
    let date: Date
    let coordinate: CoordinateRequest
}

struct CoordinateRequest: Encodable {
    let longitude: String
    let latitude: String
}
