//
//  CreateOrUpdateClassroomRequest.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import Foundation
struct CreateOrUpdateClassroomRequest: Codable {
    let _id: String
    let roomName:String
    let students:[Student]?
    let professor:Professor?
}
