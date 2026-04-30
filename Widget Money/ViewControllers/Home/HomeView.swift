//
//  HomeUIView.swift
//  Widget Money
//
//  Created by Алексей Никитин on 26.01.26.
//

import SwiftUI
import Combine




struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(vm.updateText)
                    .font(.caption)
                    .foregroundStyle(vm.textColor)
                    .padding(.trailing, 12)
                    .padding(.bottom, 5)
            }
            
            ViewControllerWrapper(viewController: CurrencyPairsListViewController())
                .frame(height: 130)
                .ignoresSafeArea(.all)
            ViewControllerWrapper(viewController: ExchangeViewController())
                .frame(height: 160)
                .ignoresSafeArea(.all)
                .padding(.horizontal, 12)
                .padding(.vertical, 15)
                
            
            BottomUIView()
                .padding(.horizontal, 12)
                .padding(.bottom, 5)
            Spacer()
            AdsLineVCWrapper(bannerID: vm.adsBannerID)
                .frame(height: 100)
                
            
        }.background(vm.backgroundColor)
        
    }
}


// Обертка для добавления UIKIt
struct ViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ничего не нужно, VC сам работает через синглтон
    }
}
