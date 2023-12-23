//
//  RealmHelper.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import RealmSwift
class RealmHelper{
    static func updateLocalClassroom(updateClassroom:Classroom){
        let realm = try! Realm()

        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", updateClassroom.beIdentifier).first{

            do{
                try! realm.write {
                    classroom.students = updateClassroom.students
                    classroom.professor = updateClassroom.professor
                }
            }
            catch(let e){
                print("updateLocalClassroom:\(self.updateLocalClassroom)")
            }

        }
    }
    static func cleanDB(){
        let realm = try! Realm()
        Student.deleteAll(in: realm)
        Professor.deleteAll(in: realm)
        Classroom.deleteAll(in: realm)
    }
}
