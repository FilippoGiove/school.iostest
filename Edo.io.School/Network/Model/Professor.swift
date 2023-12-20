//
//  Professor.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
struct Professor: Codable {
    let _id: String
    let name: String
    let email: String
    let subjects: [String]
}
