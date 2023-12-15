//
//  AuthManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 14.12.2023.
//

import Foundation

protocol AuthManager {
    func signIn(email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: AuthManager {
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let loginData = SignInRequestBody(email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/auth/login",
            method: "POST",
            requestData: loginData
        )
        UserManager.shared.set(accessToken: authResponse.accessToken)
        return authResponse
    }
}
