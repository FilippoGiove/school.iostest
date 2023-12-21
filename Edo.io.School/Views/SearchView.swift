//
//  SearchView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI
struct SearchView: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    init() {
            //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.systemFont(ofSize: 18)]

            //Use this if NavigationBarTitle is with displayMode = .inline
            //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
        }
    var body: some View {
        VStack{
            Text("SEARCH_VIEW_TITLE".localized.uppercased())
                .font(.titleFont)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,standardPadding)
            NavigationStack {
                List {
                    ForEach(searchResults, id: \.self) { name in
                        NavigationLink {
                            Text(name)
                        } label: {
                            Text(name)
                        }
                    }
                }.scrollContentBackground(.hidden)
            }
            .searchable(text: $searchText)

        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}
