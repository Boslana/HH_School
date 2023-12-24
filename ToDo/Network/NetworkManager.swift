//
//  NetworkManager.swift
//  ToDo
//
//  Created by Светлана Полоротова on 23.11.2023.
//

import Combine
import Foundation

final class NetworkManager {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(decoder: JSONDecoder, encoder: JSONEncoder) {
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<Response: Decodable>(
        urlStr: String,
        method: String,
        fileName: String? = nil,
        headers: [String: String]? = nil
    ) async throws -> Response {
        try await request(urlStr: urlStr, method: method, requestData: EmptyRequest?.none, fileName: fileName, headers: headers)
    }

    func request<Request: Encodable, Response: Decodable>(
        urlStr: String,
        method: String,
        requestData: Request? = nil,
        fileName: String? = nil,
        headers: [String: String]? = nil
    ) async throws -> Response {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let fileName, let formData = requestData as? Data {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"uploadedFile\"; filename=\"\(fileName)\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(formData)
            body.append("\r\n--\(boundary)--\r\n")
            request.httpBody = body
        } else if let requestData, method != "GET" {
            request.httpBody = try encoder.encode(requestData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200 ..< 400:
                if data.isEmpty, let emptyData = "{}".data(using: .utf8) {
                    return try decoder.decode(Response.self, from: emptyData)
                }
                return try decoder.decode(DataResponse<Response>.self, from: data).data
            case 401:
                await ParentViewController.navigateToAuth()
                throw NetworkError.unauthorized
            default:
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }
}
