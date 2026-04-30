//
//  SettingsUIView.swift
//  Widget Money
//
//  Created by Алексей Никитин on 27.01.26.
//

import SwiftUI

struct SettingsUIView: View {
    
    let vm = SettingsViewModel()
    
    @State private var isPresented: Bool = false
    @State private var appThemeViewTarget: Bool = false
    @State private var baseCoinViewTarget: Bool = false
    
    var body: some View {
        VStack {
            Image(vm.imageName)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
                .padding(.vertical, 50)
            Text("Widget Money")
                .font(.title2)
                .foregroundStyle(vm.titleColor)
                .padding(3)
            Text("Version: \(vm.appVersion)")
                .font(.callout)
                .foregroundStyle(vm.textColor)
            
            //Settings block
            HStack {
                Text("Settings")
                    .foregroundStyle(vm.textColor)
                Spacer()
            }.padding(.horizontal, 12)
            
            VStack(spacing: 0) {
                Button (action: {
                    baseCoinViewTarget = true
                    isPresented.toggle()
                }) {
                    SettingsCellView(image: "dollarsign.circle.fill", nameText: "Main currency", valueText: vm.baseCoin, textColor: vm.textColor)
                        .frame(height: 50)
                }
                
                Divider()
                    .background(vm.textColor)
                    .padding(.leading, 50)
                
                
                Button (action: {
                    appThemeViewTarget = true
                    isPresented.toggle()
                }) {
                    SettingsCellView(image: "circle.lefthalf.filled.inverse", nameText: "App theme", valueText: vm.appTheme, textColor: vm.textColor)
                        .frame(height: 50)
                }
            }
            .background(vm.widgetBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 12)
            
            
            Spacer()
            AdsLineVCWrapper(bannerID: vm.adsBannerID)
                .frame(height: 100)
        }
        .background(vm.backgroundColor)
        .fullScreenCover(isPresented: $isPresented, onDismiss: {
            appThemeViewTarget = false
            baseCoinViewTarget = false
        })
{
            if appThemeViewTarget { ViewControllerWrapper(viewController: ChangeThemeViewController())}
            if baseCoinViewTarget { ViewControllerWrapper(viewController: ChooseCurrencyViewController())}
        }
    }
}

#Preview {
    SettingsUIView()
}
