//
//  HomeViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import Foundation
class HomeViewModel: ObservableObject {
    @Published var classrooms = [Classroom]()

    func fetchClassrooms() async {

        if let url = URL(string:Endpoint.getlistClassroomUrl()){
            do {
                print("fetchClassrooms:URL-->\(url.absoluteString)")
                var request = URLRequest(url: url)
                request.setValue(
                    "Bearer \(Endpoint.getBearerToken())",
                    forHTTPHeaderField:  "Authentication")
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(ListClassroomsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.classrooms = response.classrooms
                    print("fetchClassrooms:#Classrooms: \(self.classrooms.count)")

                }
            } catch {
                print("fetchClassrooms:Error: \(error)")
            }
        }
    }


}
