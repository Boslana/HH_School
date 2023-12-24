//
//  ItemManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 15.12.2023.
//

import Foundation

protocol ItemManager {
    func createNewTodo(title: String, description: String, date: Date) async throws -> TodoItemResponseBody
    func deleteTodo(todoId: String) async throws -> EmptyResponse
}

extension NetworkManager: ItemManager {
    func createNewTodo(title: String, description: String, date: Date) async throws -> TodoItemResponseBody {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let newItemData = NewTodoItemRequestBody(title: title, description: description, date: date)
        let newTodoResponse: TodoItemResponseBody = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "POST",
            requestData: newItemData,
            headers: headers
        )
        return newTodoResponse
    }

    func deleteTodo(todoId: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let deleteResponse: EmptyResponse = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/todos/\(todoId)",
            method: "DELETE",
            headers: headers
        )
        return deleteResponse
    }
}
