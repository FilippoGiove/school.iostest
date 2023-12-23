//
//  StudentView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StudentView: View {

    @ObservedObject var viewModel:StudentViewModel

    init(_ student: Student) {
        self.viewModel = StudentViewModel(student: student)
    }

    @State private var enableBlogger = true
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    WebImage(url: URL(string: viewModel.student.avatar))
                        .resizable()
                        .placeholder {ProgressView()}
                        .clipped()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2.0))
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)

                    Spacer()
                }.listRowBackground(Color.clear)

                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("Full Name").padding(.trailing,100)
                        TextEditor(text: $viewModel.student.name).lineLimit(1)
                    }
                    HStack {
                        Text("EMAIL".localized).padding(.trailing,100)
                        TextEditor(text: $viewModel.student.email).lineLimit(1)
                    }
                }
                Section(header: Text("CLASSROOM".localized)) {
                    Text(viewModel.student.classroom)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $viewModel.student.notes)
                        .lineLimit(10)
                        .frame(height: 100)
                }
            }
        }
    }
}
