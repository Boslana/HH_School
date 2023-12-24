//
//  SignUpManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 15.12.2023.
//

import Foundation

protocol SignUpManager {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: SignUpManager {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let registrationData = SignUpRequestBody(name: name, email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/auth/registration",
            method: "POST",
            requestData: registrationData
        )
        UserManager.shared.set(accessToken: authResponse.accessToken)
        return authResponse
    }
}
