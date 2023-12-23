//
//  StudentViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import SwiftUI
import Foundation
import RealmSwift
class StudentViewModel: ObservableObject {
    @Published var student: Student
    @Published var isLoading:Bool = false
    @Published var alertUpdateMessage:String = ""
    @Published var showAlertUpdateMessage:Bool = false


    var createOrUpdateClassroomRequest:Data?
    var idClassroom:String = ""
    var idStudent:String = ""
    let realm = try! Realm()

    init(student: Student) {
        self.student = student
        self.idClassroom = student.classroom
        self.idStudent = student.beIdentifier
    }

    public func prepareUpdateStudentRequest(){
        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.idClassroom).first{


            let id = classroom.beIdentifier

            if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
                do {
                    print("createClassroom:URL-->\(url.absoluteString)")
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    var newStudentList:[Student] = []
                    let students = classroom.students
                    for s in students{
                        if(s.beIdentifier == self.student.beIdentifier){
                            newStudentList.append(self.student)
                        }
                        else{
                            newStudentList.append(s)
                        }

                    }


                    let newProfessor:Professor? = classroom.professor

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

extension StudentViewModel{
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
                    self.alertUpdateMessage = "Student info updated."
                    self.showAlertUpdateMessage = true
                }
            }
            catch{
                self.alertUpdateMessage = "Student info not updated due an error"
                self.showAlertUpdateMessage = true
            }
        }




    }
}
extension StudentViewModel{
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
