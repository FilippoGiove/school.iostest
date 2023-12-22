//
//  ClassroomViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import SwiftUI
import Foundation
class ClassroomViewModel: ObservableObject {
    @Published var classroom:Classroom
    @Published var showAlertError:Bool = false
    @Published var isLoading:Bool = false


    public var lastErrorMessage = ""


    init(classroom: Classroom) {
        self.classroom = classroom
    }

    func setProfessor(_ professor:Professor) async{
        self.classroom.professor = professor
        let _ = await self.updateClassroom()
    }

    func addStudent(student:Student) async{
        if(self.classroom.students == nil){
            self.classroom.students = []
        }
        self.classroom.students?.append(student)
        let _ = await self.updateClassroom()
    }

    func showAlertError(withMessage message:String){
        self.lastErrorMessage = message
        self.showAlertError = true
    }


    func updateClassroom() async {
        let id = classroom.id

        if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                print("createClassroom:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"

                let body = CreateOrUpdateClassroomRequest(_id: classroom.id, roomName: classroom.roomName, students: classroom.students, professor: classroom.professor)
                let requestBody = try JSONEncoder().encode(body)
                print("createClassroom:requestBody-->\(requestBody)")

                request.httpBody = requestBody
                request.setValue(
                    "Bearer \(Endpoint.getBearerToken())",
                    forHTTPHeaderField:  "Authorization")
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                let (data, _) = try await URLSession.shared.data(for: request)
                self.classroom = try JSONDecoder().decode(Classroom.self, from: data)
                DispatchQueue.main.async {
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
