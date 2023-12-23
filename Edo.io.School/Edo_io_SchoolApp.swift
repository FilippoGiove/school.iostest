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
        UserDefaults.standard.set(false, forKey: "edo.io.delete.db")

        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}


extension View {
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillAppearModifier(callback: perform))
    }
}

struct WillAppearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillAppear: callback))
    }
}

struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    var onWillAppear: () -> Void = { }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        context.coordinator
    }

    func updateUIViewController(
        _: UIViewControllerType,
        context _: UIViewControllerRepresentableContext<Self>
    ) { }

    func makeCoordinator() -> Self.Coordinator {
        Coordinator(onWillAppear: onWillAppear)
    }

    class Coordinator: UIViewControllerType {
        let onWillAppear: () -> Void

        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}
