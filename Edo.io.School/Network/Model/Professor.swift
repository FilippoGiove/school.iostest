//
//  Professor.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
struct Professor: Identifiable,Codable {
    let id: String
    let name: String
    let email: String
    let subjects: [String]
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case email = "email"
        case subjects = "subjects"
    }
}
