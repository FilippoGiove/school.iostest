//
//  Edo_io_SchoolApp.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import SwiftUI
import SDWebImageSVGCoder

@main
struct Edo_io_SchoolApp: App {
    init() {
      setUpDependencies() // Initialize SVGCoder
    }
    var body: some Scene {
        WindowGroup {
            ViewCoordinator()
        }
    }
}

// Initialize SVGCoder
private extension Edo_io_SchoolApp {

    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
