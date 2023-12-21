//
//  MainView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import SwiftUI

struct HomeView: View {

    @State var presentSettingsView = false
    @StateObject private var viewModel = HomeViewModel()



    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing){
                VStack{
                    Text("CLASSROOMS".localized.uppercased())
                        .font(.titleFont)
                    if(viewModel.classrooms.isEmpty){
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
                            ForEach(viewModel.classrooms) {
                                item in
                                VStack{
                                    Button {
                                        print("tap class \(item)")
                                    } label: {
                                        Image("ic_classroom")
                                            .font(.largeTitle)
                                            .foregroundColor(.black)
                                    }
                                    Text(item.roomName)
                                        .font(.contentFont)
                                    Spacer()
                                }.padding(.top,10)
                            }
                            .onDelete { indexSet in
                                viewModel.classrooms.remove(atOffsets: indexSet)
                            }
                        }.scrollContentBackground(.hidden)
                    }

                }
                .task {
                    await viewModel.fetchClassrooms()
                }
                .padding(.top,topPadding)
                FloatingButton(action: {
                                    // Perform some action here...
                }, icon: "plus")
            }
        }


    }
}

