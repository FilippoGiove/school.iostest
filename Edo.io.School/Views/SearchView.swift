//
//  SearchView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI
struct SearchView: View {
    @State private var searchText = ""
    @ObservedObject var viewModel: SearchViewModel

    @State var presentDetails = false

    


    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 18)]
        self.viewModel = SearchViewModel()
    }

    
    var body: some View {
        VStack{
            Text("SEARCH_VIEW_TITLE".localized.uppercased())
                .font(.titleFont)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,standardPadding)
            NavigationStack {

                //**** PROFESSORS*****/
                if(searchProfessortsResults.count > 0){
                    Text("\("PROFESSORS_FOUND".localized.uppercased())")
                        .font(.contentFontBold)
                        .padding(.top,standardPadding)



                    List {
                        ForEach(Array((searchProfessortsResults).enumerated()), id: \.offset) {
                            index, professor in
                            HStack{
                                Image("ic_professor")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                Spacer()
                                VStack{
                                    Text(professor.name.uppercased())
                                        .font(.contentFont)
                                }
                                Spacer()
                                

                                NavigationLink {
                                    ProfessorView(professor, idClassroom: professor.classroom)
                                } label: {
                                    EmptyView()
                                }
                                .frame(width: 0).opacity(0)
                                
                                Image("ic_arrow_right")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                                    .frame(width: 30, height: 30)

                

                            }.padding(.top,0)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }.scrollContentBackground(.hidden)
                }

                if(searchStudentsResults.count > 0){
                    Text("\("STUDENTS_FOUND".localized.uppercased())")
                        .font(.contentFontBold)
                        .padding(.top,standardPadding)
                    List {
                        ForEach(Array((searchStudentsResults).enumerated()), id: \.offset) {
                            index, student in
                            HStack{
                                Image("ic_desc")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)

                                Spacer()
                                VStack{
                                    Text((student as! Student).name.uppercased())
                                        .font(.contentFont)
                                }
                                Spacer()

                                NavigationLink {
                                    StudentView(student)
                                } label: {
                                    EmptyView()
                                }
                                .frame(width: 0).opacity(0)

                                Image("ic_arrow_right")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                                    .frame(width: 30, height: 30)
                            }.padding(.top,0)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }

            }
            .searchable(text: $searchText,prompt: "SEARCH_PLACEHOLDER".localized)


        }.onWillAppear  {
            print("SEARCH:REFRESH")
            viewModel.initSearchDatasource()
            //searchText = " "
            //searchText = ""



        }.onDisappear{
            print("SEARCH:CLEAR")
            searchText = ""
            viewModel.clearDependencies()
        }
    }



    var prevProf = ""
    var searchStudentsResults: [Student] {
        return viewModel.findAllStudents(withName: searchText)
    }

    var searchProfessortsResults: [Professor] {
        return viewModel.findAllProfessors(withName: searchText)
    }
}
