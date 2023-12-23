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



    func clearDependencies(){
        students = []
        professors = []
    
    }
    func initSearchDatasource(){
        let realm = try! Realm()
        self.students = Array(realm.objects(Student.self))
        self.professors = Array( realm.objects(Professor.self))
    }


    public func findAllStudents(withName searchText:String)->[Student]{
        print("findAllStudents")
        var result:[Student] = []
        if(searchText.isEmpty){
            result = []//self.students
        }
        else{
            result =  students.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        return result


    }

    public func findAllProfessors(withName searchText:String)->[Professor]{
        print("findAllProfessors")
        var result:[Professor] = []
        
        if(searchText.isEmpty){
            return []//self.professors
        }
       else{
            result = professors.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        return result

    }

}
