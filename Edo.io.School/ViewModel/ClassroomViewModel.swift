//
//  ClassroomViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import SwiftUI
import Foundation
import RealmSwift
class ClassroomViewModel: ObservableObject {
    @Published var classroomIdentidier:String
    @Published var showAlertError:Bool = false
    @Published var isLoading:Bool = false


    public var lastErrorMessage = ""

    let realm = try! Realm()

    var createOrUpdateClassroomRequest:Data?

    @Published var notshowProfessorDetailsView:Bool = false
    @Published var testShow:Bool = false

    @Published var showStudentsDetailsView:[Bool] = []
    @Published var showProfessorDetailsView:Bool = false




    init(classroom: Classroom) {
        self.classroomIdentidier = classroom.beIdentifier
        self.showStudentsDetailsView = [Bool](repeating: false, count: classroom.students.count)
    }

   

    func getProfessor()->Professor?{

        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.classroomIdentidier).first{
            return classroom.professor
        }
        else{
            return nil
        }
    }


    func getStudents()->[Student]?{

        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.classroomIdentidier).first{
            return Array(classroom.students)
        }
        else{
            return nil
        }
    }

    func getClassroom()->Classroom?{

        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.classroomIdentidier).first{
            return classroom
        }
        else{
            return nil
        }
    }

    func showAlertError(withMessage message:String){
        self.lastErrorMessage = message
        self.showAlertError = true
    }


    public func prepareCreateOrUpdateClassroomRequest(with professor:Professor?, student:Student?){
        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.classroomIdentidier).first{


            let id = classroom.beIdentifier

            if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
                do {
                    print("createClassroom:URL-->\(url.absoluteString)")
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    var newStudentList:[Student] = []
                    if let student = student{
                        newStudentList.append(contentsOf: classroom.students)
                        newStudentList.append(student)
                    }
                    else{
                        newStudentList =  Array(classroom.students)
                    }

                    var newProfessor:Professor? = nil
                    if let professor = professor {
                        newProfessor = professor
                    }
                    else{
                        newProfessor = classroom.professor
                    }

                    let createOrUpdateClassroomRequestObj = CreateOrUpdateClassroomRequest(_id: classroom.beIdentifier, roomName: classroom.roomName, students: newStudentList, professor: newProfessor)

                    do{
                        self.createOrUpdateClassroomRequest = try JSONEncoder().encode(createOrUpdateClassroomRequestObj)
                    }
                    catch{

                    }

                }
            }
        }
    }

    public func prepareDeleteStudentRequest(student:Student?){
        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", self.classroomIdentidier).first{


            let id = classroom.beIdentifier

            if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
                do {
                    print("createClassroom:URL-->\(url.absoluteString)")
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    var newStudentList:[Student] = []
                    if let student = student{
                        for s in classroom.students{
                            if(s.beIdentifier != student.beIdentifier){
                                newStudentList.append(s)
                            }
                        }
                    }
                    else{
                        newStudentList =  Array(classroom.students)
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


    func updateClassroom() async {
        let id = self.classroomIdentidier
        if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                print("createClassroom:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"

                request.httpBody = self.createOrUpdateClassroomRequest
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
                    self.updateLocalClassroom(newClassroom)
                    self.isLoading = false
                }


            } catch {
                print("createClassroom:Error: \(error)")
                self.lastErrorMessage = error.localizedDescription
                self.showAlertError = true
                self.isLoading = false

            }

        }


    }



}

extension ClassroomViewModel{
    func updateLocalClassroom(_ updateClassroom:Classroom){

        if let classroom = realm.objects(Classroom.self).filter("beIdentifier = %@", updateClassroom.beIdentifier).first{

            do{
                try! realm.write {
                    classroom.students = updateClassroom.students
                    classroom.professor = updateClassroom.professor
                }
                self.showStudentsDetailsView = [Bool](repeating: false, count: classroom.students.count)

            }
            catch(let e){
                print("updateLocalClassroom:\(self.updateLocalClassroom)")
            }

        }
    }
    func cleanDB(){
        Student.deleteAll(in: realm)
        Professor.deleteAll(in: realm)
        Classroom.deleteAll(in: realm)
    }
}
