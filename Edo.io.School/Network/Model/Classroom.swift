//
//  Classroom.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
import RealmSwift
class Classroom: Object,Identifiable, Codable  {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var beIdentifier: String
    @Persisted var roomName: String
    @Persisted var school: String
    @Persisted var students: List<Student>
    @Persisted var professor:Professor? = nil
    enum CodingKeys: String, CodingKey {
        case beIdentifier = "_id"
        case roomName = "roomName"
        case school = "school"
        case students = "students"
        case professor = "professor"
    }
    public override init() {
        super.init()
    }
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(beIdentifier, forKey: .beIdentifier)
            try container.encode(roomName, forKey: .roomName)
            try container.encode(school, forKey: .school)
            try container.encodeIfPresent(students, forKey: .students)
            try container.encodeIfPresent(professor, forKey: .professor)

        }

        required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)

            beIdentifier = try container.decode(String.self, forKey: .beIdentifier)
            roomName = try container.decode(String.self, forKey: .roomName)
            school = try container.decode(String.self, forKey: .school)

            let studentList = try container.decodeIfPresent(List<Student>.self, forKey: .students)
            if let studentList = studentList{
                students.append(objectsIn: studentList)
            }

            professor = try container.decodeIfPresent(Professor.self, forKey: .professor)


        }

    convenience init(_id: String,
                     roomName: String,
                     school: String,
                     students:[Student]?,
                     professor: Professor?
            ) {
        self.init()
        self.beIdentifier = _id
        self.school = school
        self.professor = professor
        self.students = List<Student>()
        for s in students ?? []{
            self.students.append(s)
        }
     }

    public func getNumStudentFormattedString()->String{
        let studentsCount = self.students.count ?? 0
        if /*let studentsCount = self.students?.count,studentsCount > 0*/  studentsCount > 0{
            return "(\(studentsCount) \("STUDENTS".localized) )"
        }
        else{
            return "(0 \("STUDENTS".localized))"
        }
    }

    public func getStudents()->[Student]{
        if self.students != nil{
            return Array(students)
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
        if(professor != nil){
            return true
        }
        else{
            return false
        }
    }


}

