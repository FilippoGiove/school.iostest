//
//  ClassroomView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import Foundation
import SwiftUI
import RealmSwift
struct ClassroomView: View {


    @State private var showingAddNewStudentAlert = false

    @State var presentSettingsView = false
    @State private var studentInCreationEmail = ""
    @State private var studentInCreationName = ""



    @ObservedObject var viewModel: ClassroomViewModel
    init(_ classroom: Classroom) {
        print("TAP ON \(classroom.roomName)")
        self.viewModel = ClassroomViewModel(classroom: classroom)
    }

    var body: some View {
        //NavigationStack {
        ZStack(alignment: .center){
            LoaderView(tintColor: .red, scaleSize: 1.0).padding(0).isHidden(!viewModel.isLoading)
            VStack{
                Text("\("CLASSROOM".localized.uppercased()) \(viewModel.getClassroom()?.roomName ?? "")")
                    .font(.titleFont).padding(standardPadding)


                ClassroomProfessorView(viewModel)

                /******* STUDENTS ************/

                Divider().padding(.horizontal,standardPadding)

                ClassroomStudentView(viewModel)


            }

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

                    if(studentInCreationName.isEmpty || studentInCreationEmail.isEmpty){
                        viewModel.showAlertError(withMessage: "ENTER_STUDENT_ERROR".localized)
                    }
                    else{
                        let escapedFullname = studentInCreationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Avatar"

                        let id = "\(studentInCreationName)\(studentInCreationEmail)".toBase64()

                        let avatarAPIUrl = "https://api.multiavatar.com/\(escapedFullname)"
                        let studentToAdd = Student(
                            _id: id,
                            name: studentInCreationName,
                            email: studentInCreationEmail,
                            avatar: avatarAPIUrl,
                            notes: "",
                            classroom: viewModel.classroomIdentidier)
                        viewModel.prepareCreateOrUpdateClassroomRequest(with: nil, student: studentToAdd)
                        Task {
                            let _ =  await self.viewModel.updateClassroom()
                        }
                        studentInCreationName = ""
                        studentInCreationEmail = ""
                    }

                }
            } message: {
                Text("ENTER_STUDENT_DATA".localized)
                    .font(.contentFont)
            }

        }.alert("ATTENTION".localized, isPresented:$viewModel.showAlertError) {
            Button("CLOSE".localized, role: .cancel) {

            }
        } message: {
            Text("\("ERROR_API_DETAILS".localized.uppercased())\n\(viewModel.lastErrorMessage)")
        }

    }
    //}
}


struct ClassroomStudentView: View {
    @ObservedObject var viewModel: ClassroomViewModel
    init(_ viewModel: ClassroomViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Text("\("STUDENTS".localized.uppercased())")
                            .font(.titleFont)
                            .padding(.top,standardPadding)
        List {
            ForEach(Array((viewModel.getStudents() ?? []).enumerated()), id: \.offset) {
                index, item in
                HStack{
                    Image("ic_desc")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                    Spacer()
                    Text(item.name.uppercased())
                        .font(.contentFont)
                    Spacer()
                        Button {
                            self.viewModel.showStudentsDetailsView[index].toggle()
                        } label: {
                            Image("ic_arrow_right")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .frame(width: 30, height: 30)
                        }.navigationDestination(
                            isPresented:$viewModel.showStudentsDetailsView[index]){
                                StudentView(item)
                        }
                }
                .padding(.top,0)
                 .listRowSeparator(.hidden)

            }
            .onDelete{ indexSet in
                for index in indexSet{
                    Task {
                        let student = (self.viewModel.getStudents() ?? [])[index]
                        viewModel.prepareDeleteStudentRequest(student: student)
                        Task {
                            let _ =  await self.viewModel.updateClassroom()
                        }
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

    }

}


struct ClassroomProfessorView: View {

    @State private var professorInCreationEmail = ""
    @State private var professorInCreationName = ""
    @State private var professorInCreationSubjects = ""
    @State private var showingAddNewProfessorAlert = false

    @ObservedObject var viewModel: ClassroomViewModel
    init(_ viewModel: ClassroomViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
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
                                Text(viewModel.getProfessor()?.name ?? "NO_PROFESSOR_ADDED".localized)
                                    .font(.contentFont)
                            }
                            Spacer()
                            Button {
                                if(viewModel.getProfessor() != nil){
                                    viewModel.testShow.toggle()
                                }
                                else{
                                    self.showingAddNewProfessorAlert.toggle()
                                }
                            } label: {
                                Image(viewModel.getProfessor() != nil ? "ic_arrow_right" : "ic_add")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                                    .frame(width: 30, height: 30)
                            }.navigationDestination(
                                isPresented:$viewModel.testShow){
                                    if(viewModel.getProfessor() != nil){
                                        ProfessorView(viewModel.getProfessor()!, idClassroom: viewModel.classroomIdentidier)
                                    }

                            }
                        }
                        .padding(standardPadding)
                        .alert("NEW_PROFESSOR".localized.uppercased(), isPresented: $showingAddNewProfessorAlert) {
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
                                if(professorInCreationName.isEmpty ||
                                   professorInCreationEmail.isEmpty ||
                                   professorInCreationSubjects.isEmpty){
                                    viewModel.showAlertError(withMessage: "ENTER_PROFFESSOR_ERROR".localized)
                                }
                                let escapedFullname = professorInCreationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Avatar"

                                let id = "\(professorInCreationName)\(professorInCreationEmail)".toBase64()

                                let avatarAPIUrl = "https://api.multiavatar.com/\(escapedFullname)"

                                let professor = Professor(
                                        _id: id,
                                        name: professorInCreationName,
                                        email: professorInCreationEmail,
                                        avatar: avatarAPIUrl,
                                        subjects: (professorInCreationSubjects.splitSubjects()),
                                        classroom: viewModel.classroomIdentidier
                                        )
                                self.viewModel.prepareCreateOrUpdateClassroomRequest(with: professor, student: nil)

                                Task {
                                    let _ =  await self.viewModel.updateClassroom()
                                }

                                professorInCreationName = ""
                                professorInCreationEmail = ""
                                professorInCreationSubjects = ""
                            }
                        } message: {
                            Text("ENTER_PROFESSOR_DATA".localized)
                                .font(.contentFont)
                        }

    }

}
