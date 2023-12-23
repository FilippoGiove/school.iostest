//
//  ProfessorView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfessorView: View {

    @ObservedObject var viewModel:ProfessorViewModel

    init(_ professor: Professor) {
        self.viewModel = ProfessorViewModel(professor: professor)
    }

    @State private var enableBlogger = true
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    WebImage(url: URL(string: viewModel.professor.avatar))
                        .resizable()
                        .placeholder {ProgressView()}
                        .clipped()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2.0))
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)

                    Spacer()
                }.listRowBackground(Color.clear)

                Section(header: Text("BASIC_INFO".localized)) {
                    HStack {
                        Text("FULLNAME".localized)
                            .padding(.trailing,10)
                        TextEditor(text: $viewModel.professor.name)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("EMAIL".localized)
                            .padding(.trailing,10)
                        TextEditor(text: $viewModel.professor.email)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)

                    }
                }
                Section(header: Text("SUBJECTS".localized)) {
                    Text(viewModel.professor.subjects.joined(separator: ","))
                }


            }
        }
    }
}
