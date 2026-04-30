//
//  PremiumBuyView.swift
//  Widget Money
//
//  Created by Алексей Никитин on 02.02.26.
//

import SwiftUI

struct PremiumBuyView: View {
    
    private let colorModel = CoreWorker.shared.colorsWorker.colorsObservable
    
    var body: some View {
        VStack {
            
            Image(colorModel.isDark ? "PremiumImageDark" : "PremiumImageLight")
                .resizable()
                .scaledToFit()
                .layoutPriority(1)
                .overlay(
                    colorModel.background
                        .frame(height: 24)
                        .clipShape(
                            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                        ),
                    alignment: .bottom
                )
            Text("💎 Get Premium")
                .foregroundStyle(colorModel.mainText)
                .font(.title3)
            Spacer()
            
            HStack(spacing: 0) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorModel.accentColor)
                    .padding(12)
                Text("Enjoy the app without ads")
                    .foregroundStyle(colorModel.mainText)
                Spacer()
            }
            .frame(height: 48)
            .background(colorModel.backgroundForWidgets)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 12)
            
            HStack(spacing: 0) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorModel.accentColor)
                    .padding(12)
                Text("Access the Lock Screen widget")
                    .foregroundStyle(colorModel.mainText)
                Spacer()
            }
            .frame(height: 48)
            .background(colorModel.backgroundForWidgets)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 12)
            Spacer()
            Button(action: {
                print("")
            }) {
                HStack {
                    Spacer()
                    Text("Get Premium for $1.99")
                        .font(.headline)
                        .foregroundStyle(colorModel.backgroundForWidgets)
                    Spacer()
                }
                .frame(height: 48)
                .background(colorModel.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(12)
                
            }
            
            
            Button(action: {
                print("")
            }) {
                Text("Restore purchase")
            }
            
            Spacer()
            
            
        }.background(colorModel.background)
    }
}

