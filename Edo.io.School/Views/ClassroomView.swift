//
//  ClassroomView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import Foundation
import SwiftUI

struct ClassroomView: View {


    @State private var showingAddNewStudentAlert = false
    @State private var showingAddNewProfessorAlert = false

    @State var presentSettingsView = false
    @State private var studentInCreationEmail = ""
    @State private var studentInCreationName = ""

    @State private var professorInCreationEmail = ""
    @State private var professorInCreationName = ""
    @State private var professorInCreationSubjects = ""

    @ObservedObject var viewModel: ClassroomViewModel
    init(_ classroom: Classroom) {
        print("TAP ON \(classroom.roomName)")
        self.viewModel = ClassroomViewModel(classroom: classroom)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center){
                LoaderView(tintColor: .red, scaleSize: 1.0).padding(0).isHidden(!viewModel.isLoading)
                VStack{
                    Text("\("CLASSROOM".localized.uppercased()) \(viewModel.classroom.roomName)")
                        .font(.titleFont).padding(standardPadding)


                    Text("\("PROFESSOR".localized.uppercased())")
                        .font(.titleFont)
                        .padding(.top,standardPadding)

                    HStack{
                        Image("ic_professor")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                        Spacer()
                        VStack{
                            Text(viewModel.classroom.getProfessorName())
                                .font(.contentFont)
                        }
                        Spacer()
                        Button {
                            self.showingAddNewStudentAlert.toggle()
                        } label: {
                            Image(viewModel.classroom.isThereProfessor() ? "ic_arrow_right" : "ic_add")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(standardPadding)
                    .alert("NEW_PROFESSOR".localized.uppercased(), isPresented: $showingAddNewStudentAlert) {
                        TextField("FULLNAME_REQUIRED".localized, text: $professorInCreationName)
                            .padding(.bottom,10)
                            .keyboardType(.alphabet)

                        TextField("EMAIL_REQUIRED".localized, text: $professorInCreationEmail)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        TextField("SUBJECTS".localized, text: $professorInCreationSubjects)
                            .keyboardType(.alphabet)
                            .textInputAutocapitalization(.never)

                        Button("CLOSE".localized, role: .cancel) {

                        }
                        Button("SAVE".localized){
                            Task {
                                if(professorInCreationName.isEmpty ||
                                   professorInCreationEmail.isEmpty ||
                                   professorInCreationSubjects.isEmpty){
                                    viewModel.showAlertError(withMessage: "ENTER_PROFFESSOR_ERROR".localized)
                                }
                                let escapedFullname = professorInCreationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Avatar"

                                let id = "\(professorInCreationName)\(professorInCreationEmail)".toBase64()

                                let avatarAPIUrl = "https://api.multiavatar.com/\(escapedFullname)"

                                let _ =  await self.viewModel.setProfessor(Professor(
                                    id: id,
                                    name: professorInCreationName,
                                    email: professorInCreationEmail,
                                    avatar: avatarAPIUrl,
                                    subjects: professorInCreationSubjects.splitSubjects()
                                ))
                            }
                        }
                    } message: {
                        Text("ENTER_PROFESSOR_DATA".localized)
                            .font(.contentFont)
                    }




                    /******* STUDENTS ************/

                    Divider().padding(.horizontal,standardPadding)

                    Text("\("STUDENTS".localized.uppercased())")
                        .font(.titleFont)
                        .padding(.top,standardPadding)

                    List {
                        ForEach(viewModel.classroom.getStudents()) {
                            item in
                            HStack{
                                Image("ic_desc")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                Spacer()
                                VStack{
                                    Text(item.name.uppercased())
                                        .font(.contentFont)
                                }
                                Spacer()
                                Button {
                                    print("tap class \(item)")
                                } label: {
                                    Image("ic_arrow_right")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(5)
                                        .frame(width: 30, height: 30)
                                }
                            }.padding(.top,0)

                        }
                        .onDelete{ indexSet in
                            for index in indexSet{
                                Task {
                                    let classroomId = self.viewModel.classroom.getStudents()[index].id
                                    //await viewModel.deleteClassroom(withId: classroomId)
                                }
                            }
                        }
                        .padding(0)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                        Spacer()

                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .scrollContentBackground(.hidden)
                    .padding(0)

                    FloatingButton(action: {
                        DispatchQueue.main.async {
                            self.showingAddNewStudentAlert.toggle()
                        }
                    }, icon: "plus")
                    .alert("NEW_STUDENT".localized.uppercased(), isPresented: $showingAddNewStudentAlert) {
                        TextField("FULLNAME_REQUIRED".localized, text: $studentInCreationName).padding(.bottom,10)
                        TextField("EMAIL_REQUIRED".localized, text: $studentInCreationEmail)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)

                        Button("CLOSE".localized, role: .cancel) {

                        }
                        Button("SAVE".localized){
                            Task {
                                if(studentInCreationName.isEmpty || studentInCreationEmail.isEmpty){
                                    viewModel.showAlertError(withMessage: "ENTER_STUDENT_ERROR".localized)
                                }
                                let escapedFullname = studentInCreationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Avatar"

                                let id = "\(studentInCreationName)\(studentInCreationEmail)".toBase64()

                                let avatarAPIUrl = "https://api.multiavatar.com/\(escapedFullname)"

                                let _ =  await self.viewModel.addStudent(student: Student(
                                    id: id,
                                    name: studentInCreationName,
                                    email: studentInCreationEmail,
                                    avatar: avatarAPIUrl,
                                    notes: "",
                                    classroom: viewModel.classroom.id))
                            }
                        }
                    } message: {
                        Text("ENTER_STUDENT_DATA".localized)
                            .font(.contentFont)
                    }
                }
                .task {
                }

            }.alert("ATTENTION".localized, isPresented:$viewModel.showAlertError) {
                Button("CLOSE".localized, role: .cancel) {

                }
            } message: {
                Text("\("ERROR_API_DETAILS".localized.uppercased())\n\(viewModel.lastErrorMessage)")
            }
        }
    }
}

