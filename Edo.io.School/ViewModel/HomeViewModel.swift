//
//  HomeViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import SwiftUI
import Foundation
import RealmSwift
class HomeViewModel: ObservableObject {
    @Published var classrooms = [Classroom]()
    @Published var showAlertError:Bool = false
    @Published var isLoading:Bool = false


    @Published var showClassroomDetailsView:[Bool] = []

    public var lastErrorMessage = ""


    func fetchClassrooms() async {

        let str = Endpoint.getlistClassroomUrl()
        print("fetchClassrooms:str-->\(str)")

        if let url = URL(string:Endpoint.getlistClassroomUrl()){
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                print("fetchClassrooms:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue(
                    "Bearer \(Endpoint.getBearerToken())",
                    forHTTPHeaderField:  "Authorization")
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(ListClassroomsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.showClassroomDetailsView = [Bool](repeating: false, count: response.classrooms.count)
                    print("fetchClassrooms:#showClassroomDetailsView: \(self.showClassroomDetailsView.count)")
                    self.classrooms = response.classrooms
                    self.updateLocalClassroom()
                    self.isLoading = false
                    print("fetchClassrooms:#Classrooms: \(self.classrooms.count)")
                }
            } catch {

                DispatchQueue.main.async {
                    print("fetchClassrooms:Error: \(error)")
                    self.showClassroomDetailsView = []
                    self.classrooms = []
                    self.updateLocalClassroom()
                    self.lastErrorMessage = error.localizedDescription
                    self.showAlertError = true
                    self.isLoading = false
                }
            }
        }
    }

    func createClassroom(withName name:String) async {
        let id = getNextClassroomId()

        if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                print("createClassroom:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                let body = CreateOrUpdateClassroomRequest(_id: id, roomName: name, students: nil, professor: nil)
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
                let _ = try JSONDecoder().decode(CreateOrUpdateClassroomResponse.self, from: data)

                await self.fetchClassrooms()

            } catch {
                print("createClassroom:Error: \(error)")
                self.lastErrorMessage = error.localizedDescription
                self.showAlertError = true
                self.isLoading = false

            }
        }
    }



    func deleteClassroom(withId id:String) async {

        if let url = URL(string:Endpoint.getCreateClassroomUrl(withId: id)){
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                print("createClassroom:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"

                request.setValue(
                    "Bearer \(Endpoint.getBearerToken())",
                    forHTTPHeaderField:  "Authorization")
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                let (data, _) = try await URLSession.shared.data(for: request)
                let _ = try JSONDecoder().decode(DeleteClassroomResponse.self, from: data)
                await self.fetchClassrooms()

            } catch {
                print("createClassroom:Error: \(error)")
                self.lastErrorMessage = error.localizedDescription
                self.showAlertError = true
                self.isLoading = false

            }
        }
    }


    func getNextClassroomId()->String{
        let now = Date().timeIntervalSince1970
        let school = Endpoint.getBearerToken()
        let id = "\(now)\(school)".replacingOccurrences(of: ".", with: "")
        return "C\(id)"
    }
}



extension HomeViewModel{
    func updateLocalClassroom(){
        let realm = try! Realm()
        cleanDB()
        do{
            try! realm.write {
                realm.add(self.classrooms)
            }
        }
        catch{
        }

    }
    func cleanDB(){
        let realm = try! Realm()
        Student.deleteAll(in: realm)
        Professor.deleteAll(in: realm)
        Classroom.deleteAll(in: realm)
    }
}

extension Object {
    static func deleteAll(`in` realm: Realm) {
        let allObjects = realm.objects(self)
        do{
            try realm.write {
                realm.delete(allObjects)
            }
        }
        catch{

        }
    }
}
