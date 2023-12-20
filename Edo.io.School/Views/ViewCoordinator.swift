//
//  ViewCoordinator.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import Foundation
import SwiftUI
struct ViewCoordinator: View {
    @State private var isActive = false
    var body: some View {
        SplashView(isActive: isActive)
    }
}
