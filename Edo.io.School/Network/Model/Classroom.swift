//
//  Classroom.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
struct Classroom: Codable {
    let _id: String
    let roomName: String
    let school: String
    let students: [Student]?
    let professort:Professor?
}
