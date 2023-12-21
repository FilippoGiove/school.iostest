//
//  FloatingButton.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI
struct FloatingButton: View {
    let action: () -> Void
    let icon: String
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 40, height: 40)
                .background(Color.black)
                .cornerRadius(30)
                .shadow(radius: 10)
                .offset(x: -25, y: 10)
                .padding(.vertical, standardPadding)
            }

        }
    }
}
