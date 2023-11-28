//
//  NetworkManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 23.11.2023.
//

import Foundation
import Combine

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()
    
    private func request<Request: Encodable, Response: Decodable>(
        urlStr: String,
        method: String,
        requestData: Request? = nil,
        headers: [String: String]? = nil
    ) async throws -> Response {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let requestData = requestData, method != "GET" {
            request.httpBody = try encoder.encode(requestData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.wrongResponse
        }
        
        guard (200..<400).contains(httpResponse.statusCode) else {
            throw NetworkError.wrongStatusCode
        }
        
        return try decoder.decode(DataResponse<Response>.self, from: data).data
    }
    
    private func requestForStatusCode(
        urlStr: String,
        method: String,
        headers: [String: String]? = nil
    ) async throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.wrongResponse
        }
        
        guard (200..<400).contains(httpResponse.statusCode) else {
            throw NetworkError.wrongStatusCode
        }
        
        return
    }
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let loginData = SignInRequestBody(email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlStr: "\(PlistFiles.cfApiBaseUrl)/api/auth/login",
            method: "POST",
            requestData: loginData
        )
        UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
        return authResponse
    }
    
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let registrationData = SignUpRequestBody(name: name, email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlStr: "\(PlistFiles.cfApiBaseUrl)/api/auth/registration",
            method: "POST",
            requestData: registrationData
        )
        UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
        return authResponse
    }
    
    func fetchTodoList() async throws -> [TodoItemResponseBody] {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let todosResponse: [TodoItemResponseBody] = try await request(
            urlStr: "\(PlistFiles.cfApiBaseUrl)/api/todos",
            method: "GET",
            requestData: EmptyRequest(),
            headers: headers
        )
        return todosResponse
    }
    
    func createNewTodo(category: String, title: String, description: String, date: Date, coordinate: CoordinateRequest ) async throws -> TodoItemResponseBody {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let newItemData = NewTodoItemRequestBody(category: category, title: title, description: description, date: date, coordinate: coordinate)
        let newTodoResponse: TodoItemResponseBody = try await request(
            urlStr: "\(PlistFiles.cfApiBaseUrl)/api/todos",
            method: "POST",
            requestData: newItemData,
            headers: headers
        )
        return newTodoResponse
    }
    
    func markCompletion(todoId: String) async throws {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        try await requestForStatusCode(
            urlStr: "\(PlistFiles.cfApiBaseUrl)/api/todos/mark/\(todoId)",
            method: "PUT",
            headers: headers
        )
    }
}
