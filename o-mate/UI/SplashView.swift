//
//  SplashView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

struct SplashView: View {
    var progress: Double
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            let view = Image("SplashScreen")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 128)
                .padding([.top, .bottom], 64)
            if colorScheme == .dark {
                VStack {
                    view.colorInvert()
                    ProgressView(progress: progress).padding([.leading, .trailing], 100)
                }
            } else {
                VStack {
                    view
                    ProgressView(progress: progress).padding([.leading, .trailing], 100)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .zIndex(1)
    }
}

#Preview {
    SplashView(progress: 0.8)
}
