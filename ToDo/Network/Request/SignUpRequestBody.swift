//
//  SignUpRequestBody.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.11.2023.
//

import Foundation

struct SignUpRequestBody: Encodable {
    let name: String
    let email: String
    let password: String
}
