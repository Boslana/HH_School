//
//  SingINRequestBody.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.11.2023.
//

import Foundation

struct SignInRequestBody: Encodable {
    let email: String
    let password: String
}
