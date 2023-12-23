//
//  SettingsView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
import SwiftUI
import RealmSwift
struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            Text("SETTINGS".localized.uppercased())
                .font(.titleFont)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,standardPadding)
            HStack{
                Button {
                    cleanDB()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("ic_logout")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                Text("LOGOUT".localized)
                Spacer()
            }.padding(standardPadding)
        
            Spacer()
        }
    }

    func cleanDB(){
        let realm = try! Realm()
        Student.deleteAll(in: realm)
        Professor.deleteAll(in: realm)
        Classroom.deleteAll(in: realm)
    }
}
