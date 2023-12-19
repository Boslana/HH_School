//
//  ProfileManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 15.12.2023.
//

import Foundation

protocol ProfileManager {
    func profile() async throws -> ProfileResponse
    func uploadProfilePhoto(imageData: Data, fileName: String) async throws -> EmptyResponse
}

extension NetworkManager: ProfileManager {
    func profile() async throws -> ProfileResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let profileResponse: ProfileResponse = try await request(
            urlStr: "\(PlistFiles.apiBaseUrl)/api/user",
            method: "GET",
            headers: headers
        )
        return profileResponse
    }

    func uploadProfilePhoto(imageData: Data, fileName: String) async throws -> EmptyResponse {
        guard let accessToken = UserManager.shared.accessToken else {
            throw NetworkError.wrongResponse
        }
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let urlStr = "\(PlistFiles.apiBaseUrl)/api/user/photo"

        return try await request(
            urlStr: urlStr,
            method: "POST",
            requestData: imageData,
            fileName: fileName,
            headers: headers
        )
    }
}
