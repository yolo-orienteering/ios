//
//  ProgressView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

struct ProgressView: View {
    var progress: Double
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width))
            }
        }
        .frame(height: 2)
        .animation(progress <= 0.1 ? .none : .linear, value: progress)
        .opacity(progress < 1 ? 1.0 : 0.0)
    }
}

#Preview {
    ProgressView(progress: 0.6)
}
