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
    var students:[Student] = []
    var professors:[Professor] = []

    var filteredStudents:[Student] = []
    var filteredProfessors:[Professor] = []



    let realm = try! Realm()


    func initSearchData(){
        getAllStudents()
        getAllProfessors()

    }

    private func getAllStudents(){
        let studentsFromRealm = realm.objects(Student.self)
        self.students = Array(studentsFromRealm)
        print("FOUND:\(students.count) students")
    }

    private func getAllProfessors(){
        let professorsFromRealm = realm.objects(Professor.self)
        self.professors = Array(professorsFromRealm)
        print("FOUND:\(professors.count) professors")

    }

    public func findAllStudents(withName searchText:String){
        if(searchText.isEmpty){
            self.filteredStudents = self.students
        }
        else{
            self.filteredStudents =  (students).filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

    }

    public func findAllProfessors(withName searchText:String){
        if(searchText.isEmpty){
            self.filteredProfessors = self.professors
        }
        else{
            self.filteredProfessors = (professors).filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

    }

}
