//
//  MainView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import SwiftUI

struct HomeView: View {

    @State var presentSettingsView = false

    @State fileprivate var items = [
        "\("CLASSROOM".localized.uppercased()) 1",
        "\("CLASSROOM".localized.uppercased()) 2",
        "\("CLASSROOM".localized.uppercased()) 3",
        "\("CLASSROOM".localized.uppercased()) 4",
        "\("CLASSROOM".localized.uppercased()) 5",
        "\("CLASSROOM".localized.uppercased()) 6",
        "\("CLASSROOM".localized.uppercased()) 7",
     ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing){
                VStack{
                    Text("CLASSROOMS".localized.uppercased())
                        .font(.titleFont)
                    List {
                        ForEach(items, id: \.self) { item in
                            VStack{
                                Button {
                                    print("tap class \(item)")
                                } label: {
                                    Image("ic_classroom")
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                }
                                Text(item)
                                    .font(.contentFont)
                                Spacer()
                            }.padding(.top,10)
                        }
                        .onDelete { indexSet in
                           items.remove(atOffsets: indexSet)
                        }
                      }
                    .scrollContentBackground(.hidden)
                }
                .padding(.top,topPadding)
                FloatingButton(action: {
                                    // Perform some action here...
                }, icon: "plus")
            }
        }


    }
}

