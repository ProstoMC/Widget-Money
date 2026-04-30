//
//  AdsLineView.swift
//  Widget Money
//
//  Created by sloniklm on 26.01.26.
//

import UIKit
import YandexMobileAds
import SwiftUI

class AdsLineView: UIView {
    
    var yaSmallAdsBlock: AdView!
    var bannerID: String
    
    init(bannerID: String) {
        self.bannerID = bannerID
        super.init(frame: .zero)
        createAdBlock()
        
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}

extension AdsLineView {
    func createAdBlock() {
        yaSmallAdsBlock = {
            let width = UIScreen.main.bounds.width
            let adSize = BannerAdSize.stickySize(withContainerWidth: width)
            
            let adView = AdView(adUnitID: self.bannerID, adSize: adSize)
            adView.translatesAutoresizingMaskIntoConstraints = false
            return adView
        }()
        
        self.addSubview(yaSmallAdsBlock)
        
        NSLayoutConstraint.activate([
            yaSmallAdsBlock.topAnchor.constraint(equalTo: self.topAnchor),
            yaSmallAdsBlock.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            yaSmallAdsBlock.leftAnchor.constraint(equalTo: self.leftAnchor),
            yaSmallAdsBlock.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        yaSmallAdsBlock.loadAd()
    }
}


struct AdsLineViewWrapper: UIViewRepresentable {

    let bannerID: String

    func makeUIView(context: Context) -> AdsLineView {
        AdsLineView(bannerID: bannerID)
    }

    func updateUIView(_ uiView: AdsLineView, context: Context) {
        // если параметр НЕ меняется — ничего не делаем
    }
}
