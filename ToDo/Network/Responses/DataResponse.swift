//
//  DataResponse.swift
//  ToDo
//
//  Created by Светлана Полоротова on 23.11.2023.
//

import Foundation

struct DataResponse<T: Decodable>: Decodable {
    let data: T
}
