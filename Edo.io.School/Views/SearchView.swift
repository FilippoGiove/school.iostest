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
                        ForEach(searchProfessortsResults) {
                            professor in
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
                                Button {
                                } label: {
                                    Image("ic_arrow_right")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(5)
                                        .frame(width: 30, height: 30)
                                }.navigationDestination(
                                    isPresented: $presentDetails) {
                                        Text("TAP ON \(professor.name)")
                                }

                            }.padding(.top,0)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }.scrollContentBackground(.hidden)

                    //Divider().padding(standardPadding)
                }

                if(searchStudentsResults.count > 0){
                    Text("\("STUDENTS_FOUND".localized.uppercased())")
                        .font(.contentFontBold)
                        .padding(.top,standardPadding)
                    List {
                        ForEach(searchStudentsResults, id: \.self) {
                            student in
                            HStack{
                                Image("ic_desc")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)

                                Spacer()
                                VStack{
                                    Text(student.name.uppercased())
                                        .font(.contentFont)
                                }
                                Spacer()
                                NavigationStack{
                                    Button {
                                    } label: {
                                        Image("ic_arrow_right")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(5)
                                            .frame(width: 30, height: 30)
                                    }
                                }.navigationDestination(
                                    isPresented: $presentDetails) {
                                        Text("TAP ON \(student.name)")
                                }
                            }.padding(.top,0)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }.scrollContentBackground(.hidden)
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
        print("searchStudentsResults WITH \(searchText)")
        return viewModel.findAllStudents(withName: searchText)

    }

    var searchProfessortsResults: [Professor] {
        print("searchProfessortsResults WITH \(searchText)")
        return viewModel.findAllProfessors(withName: searchText)

    }
}
