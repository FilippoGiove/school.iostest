//
//  SplashView.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 19/12/23.
//

import Foundation
import SwiftUI

struct SplashView: View {

    @State var isActive: Bool = false
    @State private var scale = 0.7

    var body: some View {
        if(isActive){
            TabbedBar()
        }
        else{
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    VStack {
                        Image("ic_desc")
                            .resizable()
                            .foregroundColor(.white)      .scaledToFit()
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                        Text("Edo.Io School APP")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.01)

                    }.scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeIn(duration: 0.7)) {
                            self.scale = 0.9
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            print("---end splash----")
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }


}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
