//
//  BottomBlockView.swift
//  Widget Money
//
//  Created by admin on 25.04.24.
//

import UIKit
import GoogleMobileAds
import RxSwift

class BottomBlockView: UIView {
    let bag = DisposeBag()
    var detailsViewController = DetailsViewController()
    var bigAdsBlock = GADBannerView()
    var littleAdsBlock = GADBannerView()
    
    //AdMob block ID
    //Tests:
    let adsBlockIDTest = "ca-app-pub-3940256099942544/2435281174"
    //Prodaction
    //let adBlockID = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        rxSubscribing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        rxSubscribing()
    }
    
    func rxSubscribing() {
        //Appearing of view
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe { flag in
            self.detailsViewController.view.isHidden = !flag
            self.littleAdsBlock.isHidden = !flag
            self.bigAdsBlock.isHidden = flag
            self.detailsViewController.configure()
            print("DETAILS UPDATE")
            print(flag)
        }.disposed(by: bag)
    }
    
}

// MARK: - SETUP UI

extension BottomBlockView {
    private func setupUI() {
        setupDetailsVC()
        setupBigAdsBlock()
        setupLittleAdsBlock()
    }
    
    private func setupDetailsVC() {
        detailsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsViewController.view)
        let detailsView = detailsViewController.view!
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: self.topAnchor),
            detailsView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            detailsView.widthAnchor.constraint(equalTo: self.widthAnchor),
            detailsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.66)
        ])
    }
    
    
    private func setupBigAdsBlock() {
        
        //let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
        let adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
        
        bigAdsBlock = GADBannerView(adSize: adSize)
        
        bigAdsBlock.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bigAdsBlock)
        
        NSLayoutConstraint.activate([
            bigAdsBlock.topAnchor.constraint(equalTo: self.topAnchor),
            bigAdsBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        bigAdsBlock.adUnitID = adsBlockIDTest
        bigAdsBlock.load(GADRequest())
        
    }
    
    private func setupLittleAdsBlock() {
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
       // let adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
        
        littleAdsBlock = GADBannerView(adSize: adSize)
        
        littleAdsBlock.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(littleAdsBlock)
        littleAdsBlock.isHidden = true
        
        NSLayoutConstraint.activate([
            littleAdsBlock.topAnchor.constraint(
                equalTo: detailsViewController.view.bottomAnchor,
                constant: UIScreen.main.bounds.height*0.05),
            littleAdsBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        littleAdsBlock.adUnitID = adsBlockIDTest
        littleAdsBlock.load(GADRequest())
        
    }
}
