//
//  StudentView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 22/12/23.
//

import SwiftUI
struct StudentView: View {
    @State private var enableBlogger = true
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    Image("anmol")
                        .resizable()
                        .clipped()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2.0))
                    Spacer()
                }

                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("First Name")
                        Spacer(minLength: 100)
                        Text("Anmol")
                    }
                    HStack {
                        Text("Last Name")
                        Spacer(minLength: 100)
                        Text("Maheshwari")
                    }
                }
                Section(header: Text("Additional")) {
                    HStack {
                        Text("Gender")
                        Spacer(minLength: 100)
                        Text("Male")
                    }
                    Toggle(isOn: $enableBlogger) {
                        Text("Blogger")
                    }
                }
            }.navigationBarTitle(Text("Profile"))
        }
    }
}
