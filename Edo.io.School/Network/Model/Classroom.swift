//
//  Classroom.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
struct Classroom: Identifiable,Codable {
    let id: String
    let roomName: String
    let school: String
    let students: [Student]?
    let professort:Professor?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case roomName = "roomName"
        case school = "school"
        case students = "students"
        case professort = "professort"
    }
}
