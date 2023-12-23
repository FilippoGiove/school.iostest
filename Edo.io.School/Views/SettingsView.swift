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

    @StateObject private var viewModel = SettingsViewModel()


    var body: some View {
        VStack{
            Text("SETTINGS".localized.uppercased())
                .font(.titleFont)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,standardPadding)
            HStack{
                Button {
                    viewModel.cleanDB()
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
        .alert("".localized, isPresented:$viewModel.showAlerteMessage) {
            Button("CLOSE".localized, role: .cancel) {

            }
        } message: {
            Text("\(viewModel.alertMessage)")
        }
    }

   
}
