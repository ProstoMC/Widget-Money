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
    var smallAdsBlock = GADBannerView()
    
    let bigBannerID = CoreWorker.shared.adsWorker.returnBannerID(bannerType: .mainBigBannerID)
    let smallBannerID = CoreWorker.shared.adsWorker.returnBannerID(bannerType: .mainSmallBannerID)
    var adsShouldBeHidden = false
    
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
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe(onNext: { flag in
            print("ADS SHOULD BE HIDDEN: \(self.adsShouldBeHidden)")
            // Check should we hide ads or not (In-app purchse)
            self.updateStatus(flag: flag)
            print("DETAILS UPDATE")
            print(flag)
        }).disposed(by: bag)
        
        CoreWorker.shared.purchaseWorker.rxAdsIsHidden.subscribe(onNext: { isHidden in
            self.adsShouldBeHidden = isHidden
            //Hide banners because we have purchase
            if isHidden {
                self.updateStatus(flag: true)
            }
        }).disposed(by: bag)
        
    }
    
    func updateStatus(flag: Bool){
        if adsShouldBeHidden {
            detailsViewController.view.isHidden = !self.adsShouldBeHidden
            smallAdsBlock.isHidden = self.adsShouldBeHidden
            bigAdsBlock.isHidden = self.adsShouldBeHidden
        } else {
            detailsViewController.view.isHidden = !flag
            smallAdsBlock.isHidden = !flag
            bigAdsBlock.isHidden = flag
        }
        detailsViewController.configure()
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
        
        bigAdsBlock.adUnitID = bigBannerID
        bigAdsBlock.load(GADRequest())
        bigAdsBlock.isHidden = true
        
    }
    
    private func setupLittleAdsBlock() {
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
       // let adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
        
        smallAdsBlock = GADBannerView(adSize: adSize)
        
        smallAdsBlock.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(smallAdsBlock)
        smallAdsBlock.isHidden = true
        
        NSLayoutConstraint.activate([
            smallAdsBlock.topAnchor.constraint(
                equalTo: detailsViewController.view.bottomAnchor,
                constant: UIScreen.main.bounds.height*0.05),
            smallAdsBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        smallAdsBlock.adUnitID = smallBannerID
        smallAdsBlock.load(GADRequest())
        
    }
}
