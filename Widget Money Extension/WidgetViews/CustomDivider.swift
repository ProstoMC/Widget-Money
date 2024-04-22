//
//  CustomDivider.swift
//  Widget Money
//
//  Created by admin on 22.04.24.
//

import SwiftUI


struct CustomDivider: View {
    

    init(percent: CGFloat) {
        self.percent = percent
    }
    
    let percent: CGFloat
    
    let color: Color = .gray
    let height: CGFloat = 0.5
    var body: some View {
        GeometryReader { reader in //For resizing
            HStack(spacing: 0) {
                Rectangle()//transparent part
                    .fill(color.opacity(0))
                    .frame(width: reader.size.width*(1-percent), height: height)
                    .edgesIgnoringSafeArea(.horizontal)
                Rectangle()
                    .fill(color.opacity(0.3))
                    .frame(height: height)
                    .edgesIgnoringSafeArea(.horizontal)
            }
            
        }
    }
}

#Preview {
    CustomDivider(percent: 50)
}
