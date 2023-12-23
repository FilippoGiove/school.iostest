//
//  ProfessorViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import Foundation
import SwiftUI
import Foundation
import RealmSwift



import RealmSwift
class ProfessorViewModel: ObservableObject {
    @Published var isLoading:Bool = false
    @Published var alertUpdateMessage:String = ""
    @Published var showAlertUpdateMessage:Bool = false


    var createOrUpdateClassroomRequest:Data?
    var idClassroom:String = ""
    var idStudent:String = ""
    let realm = try! Realm()

    @Published var professor: Professor

    init(professor: Professor, idClassroom:String) {
        self.professor = professor
        self.idClassroom = idClassroom
    }

    public func prepareUpdateProfessorRequest(){
        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.idClassroom).first{


            let id = classroom.beIdentifier

            if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
                do {
                    print("createClassroom:URL-->\(url.absoluteString)")
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    let newStudentList:[Student] = Array(classroom.students)
                    let newProfessor:Professor? = self.professor

                    let createOrUpdateClassroomRequestObj = CreateOrUpdateClassroomRequest(_id: classroom.beIdentifier, roomName: classroom.roomName, students: (newStudentList.isEmpty ? nil : newStudentList), professor: newProfessor)

                    do{
                        self.createOrUpdateClassroomRequest = try JSONEncoder().encode(createOrUpdateClassroomRequestObj)
                    }
                    catch{

                    }

                }
            }
        }
    }

}

extension ProfessorViewModel{
    func updateClassroom() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }

        if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: idClassroom)){
            let createOrUpdateClassroomRequestObj = createOrUpdateClassroomRequest
            do{
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.httpBody = createOrUpdateClassroomRequestObj
                request.setValue(
                    "Bearer \(Endpoint.getBearerToken())",
                    forHTTPHeaderField:  "Authorization")
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                let (data, _) = try await URLSession.shared.data(for: request)

                let newClassroom = try JSONDecoder().decode(Classroom.self, from: data)

                DispatchQueue.main.async {
                    self.updateLocalClassroom(realm: self.realm, updateClassroom: newClassroom)
                    self.isLoading = false
                    self.alertUpdateMessage = "Professor info updated."
                    self.showAlertUpdateMessage = true
                }
            }
            catch{
                self.alertUpdateMessage = "Professor info not updated due an error"
                self.showAlertUpdateMessage = true
            }
        }




    }
}
extension ProfessorViewModel{
    func updateLocalClassroom(realm:Realm, updateClassroom:Classroom){

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

}
