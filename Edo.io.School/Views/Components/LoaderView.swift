//
//  LoaderView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import SwiftUI
struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0

    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}
