//
//  NetworkError.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.11.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case unauthorized, wrongStatusCode, wrongURL, wrongResponse

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return nil
        case .wrongStatusCode:
            return L10n.NetworkError.wrongStatusCode
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        case .wrongURL:
            return L10n.NetworkError.wrongUrl
        }
    }
}
