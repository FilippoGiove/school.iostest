//
//  SearchViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 22/12/23.
//

import Foundation
import SwiftUI
import Foundation
import RealmSwift
class SearchViewModel: ObservableObject {
    @Published var students:[Student]?
    @Published var professors:[Professor]?

    public func getAllStudents(withName name:String){
        let realm = try! Realm()
        let students = realm.objects(Student.self).filter("name CONTAINS \(name)")
        let array = Array(students)
        self.students = array
    }

    public func getAllProfessor(withName name:String){
        let realm = try! Realm()
        let professors = realm.objects(Professor.self).filter("name CONTAINS \(name)")
        let array = Array(professors)
        self.professors = array
    }

}
