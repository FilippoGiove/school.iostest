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

    init(_ professor: Professor, idClassroom:String) {
        self.viewModel = ProfessorViewModel(professor: professor,idClassroom:idClassroom)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .center){
                LoaderView(tintColor: .red, scaleSize: 1.0).padding(0).isHidden(!viewModel.isLoading)
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
            .alert("".localized, isPresented:$viewModel.showAlertUpdateMessage) {
                Button("CLOSE".localized, role: .cancel) {

                }
            } message: {
                Text("\(viewModel.alertUpdateMessage)")
            }
        }
        .toolbar {
            Button("SAVE".localized) {
                viewModel.prepareUpdateProfessorRequest()
                Task{
                    await viewModel.updateClassroom()
                }
            }

        }
    }
}
