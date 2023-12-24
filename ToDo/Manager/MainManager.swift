//
//  MainManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 15.12.2023.
//

import Foundation

protocol MainManager {
    func fetchTodoList() async throws -> [TodoItemResponseBody]
    func markCompletion(todoId: String) async throws -> EmptyResponse
}

extension NetworkManager: MainManager {
    func fetchTodoList() async throws -> [TodoItemResponseBody] {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let todosResponse: [TodoItemResponseBody] = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "GET",
            headers: headers
        )
        return todosResponse
    }

    func markCompletion(todoId: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let markResponse: EmptyResponse = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/todos/mark/\(todoId)",
            method: "PUT",
            headers: headers
        )
        return markResponse
    }
}
