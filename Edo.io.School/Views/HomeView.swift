//
//  MainView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showingAddClassroomAlert = false


    @State var presentSettingsView = false
    @State private var classroomInCreationName = ""

    @StateObject private var viewModel = HomeViewModel()
   


    var body: some View {
        NavigationStack {
            ZStack(alignment: .center){
                LoaderView(tintColor: .red, scaleSize: 1.0).padding(0).isHidden(!viewModel.isLoading)
                VStack{
                    Text("CLASSROOMS".localized.uppercased())
                        .font(.titleFont)
                    if(viewModel.classrooms.isEmpty && !viewModel.isLoading){
                        VStack{
                            Spacer()
                            Text("NO_CLASSROOM_MESSAGE".localized)
                                .font(.titleFont)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal,24)
                            Image("ic_arrow_bottom_right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Spacer()
                        }
                    }
                    else{

                        List {
                            ForEach(Array(viewModel.classrooms.enumerated()), id: \.offset) {
                                index, item in
                                HStack{
                                    VStack{
                                        Image("ic_classroom")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.black)
                                            .frame(width: 24, height: 24)
                                        Text("CLASSROOM".localized)
                                            .font(.contentFont)
                                    }

                                    VStack{
                                        Text(item.roomName.uppercased())
                                            .font(.contentFont)
                                        Text(item.getNumStudentFormattedString())
                                            .font(.smallFont)
                                    }.padding(.leading,standardPadding)

                                    Spacer()
                                    NavigationStack{
                                        Button {
                                            self.viewModel.showClassroomDetailsView[index].toggle()
                                            //self.showClassroomDetailsView.toggle()

                                        } label: {
                                            NavigationLink(destination: ClassroomView(item), isActive: $viewModel.showClassroomDetailsView[index], label: {EmptyView()})
                                        }
                                    }



                                    /*.sheet(isPresented: $viewModel.showClassroomDetailsView[index]){
                                        ClassroomView(item)
                                    }*/
                                }.padding(.top,10)

                            }
                            .onDelete{ indexSet in
                                for index in indexSet{
                                    Task {
                                        let classroomId = self.viewModel.classrooms[index].id
                                        await viewModel.deleteClassroom(withId: classroomId)
                                    }
                                }
                            }

                        }
                        .refreshable {
                            await viewModel.fetchClassrooms()
                        }
                        .scrollContentBackground(.hidden)
                    }

                }
                .task {
                    await viewModel.fetchClassrooms()
                }
                .padding(.top,standardPadding)
                FloatingButton(action: {
                    DispatchQueue.main.async {
                        self.showingAddClassroomAlert.toggle()
                    }
                }, icon: "plus")
                .alert("NEW_CLASSROOM".localized.uppercased(), isPresented: $showingAddClassroomAlert) {
                    TextField("".localized, text: $classroomInCreationName)
                    Button("CLOSE".localized, role: .cancel) {

                    }
                    Button("SAVE".localized){
                        Task {
                            let _ =  await self.viewModel.createClassroom(withName:classroomInCreationName)
                        }
                    }
                } message: {
                    Text("ENTER_CLASSROOM_NAME".localized)
                        .font(.contentFont)
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

