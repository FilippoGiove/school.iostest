//
//  SettingsViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import SwiftUI
import Foundation
import RealmSwift
class SettingsViewModel: ObservableObject {

    @Published var alertMessage:String = ""
    @Published var showAlerteMessage:Bool = false



    func cleanDB(){
        let realm = try! Realm()
        Student.deleteAll(in: realm)
        Professor.deleteAll(in: realm)
        Classroom.deleteAll(in: realm)
        UserDefaults.standard.set(true, forKey: "edo.io.delete.db")

        DispatchQueue.main.async {
            self.alertMessage = "DB_DELETED".localized
            self.showAlerteMessage = true
        }
    }

}
