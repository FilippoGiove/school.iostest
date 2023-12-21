//
//  Student.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
struct Student: Identifiable,Codable {
    let id: String
    let name: String
    let email: String
    let avatar: String
    let notes: String
    let classroom: String
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case email = "email"
        case avatar = "avatar"
        case notes = "notes"
        case classroom = "classroom"
    }
}
