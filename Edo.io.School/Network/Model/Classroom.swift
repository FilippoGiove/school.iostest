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
    var students: [Student]?
    var professor:Professor?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case roomName = "roomName"
        case school = "school"
        case students = "students"
        case professor = "professor"
    }

    public func getNumStudentFormattedString()->String{
        if let studentsCount = self.students?.count,studentsCount > 0{
            return "(\(studentsCount) \("STUDENTS".localized) )"
        }
        else{
            return "(0 \("STUDENTS".localized))"
        }
    }

    public func getStudents()->[Student]{
        if let students = self.students{
            return students
        }
        else{
            return []
        }
    }

    public func getProfessorName()->String{
        if let professor = self.professor{
            return professor.name
        }
        else{
            return "NO_PROFESSOR_ADDED".localized
        }
    }
    public func isThereProfessor()->Bool{
        if let professor = self.professor{
            return true
        }
        else{
            return false
        }
    }


}
