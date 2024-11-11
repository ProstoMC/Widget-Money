//
//  BottomBlockView.swift
//  Widget Money
//
//  Created by admin on 25.04.24.
//

import UIKit
import GoogleMobileAds
import RxSwift
import YandexMobileAds

class BottomBlockView: UIView {
    let bag = DisposeBag()
    var detailsViewController = DetailsViewController()

    
    //YANDEX AD BANNERS
    var yaBigAdsBlock: AdView = {
        let adSize = BannerAdSize.inlineSize(
            withWidth: CGFloat(Int(UIScreen.main.bounds.width * 0.92)),
            maxHeight: CGFloat(Int(UIScreen.main.bounds.width*0.6))
        )
        
        let bannerID = CoreWorker.shared.adsWorker.returnYABannerID(bannerType: .yaMainBigBannerID)
        let adView = AdView(adUnitID: bannerID, adSize: adSize)
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    var yaSmallAdsBlock: AdView = {
        let width = UIScreen.main.bounds.width
        let adSize = BannerAdSize.stickySize(withContainerWidth: width)
        
        let bannerID = CoreWorker.shared.adsWorker.returnYABannerID(bannerType: .yaMainSmallBannerID)
        let adView = AdView(adUnitID: bannerID, adSize: adSize)
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()

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
            yaBigAdsBlock.isHidden = self.adsShouldBeHidden
            yaSmallAdsBlock.isHidden = self.adsShouldBeHidden
        } else {
            detailsViewController.view.isHidden = !flag
            yaSmallAdsBlock.isHidden = !flag
            yaBigAdsBlock.isHidden = flag
        }
        detailsViewController.configure()
    }
    
}

// MARK: - SETUP UI

extension BottomBlockView {
    private func setupUI() {
        setupDetailsVC()
        setupAdsBlocks()
        
    }
    
    private func setupDetailsVC() {
        detailsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsViewController.view)
        let detailsView = detailsViewController.view!
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: self.topAnchor),
            detailsView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            detailsView.widthAnchor.constraint(equalTo: self.widthAnchor),
            detailsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.63)
        ])
    }
    
    
    private func setupAdsBlocks() {
        yaBigAdsBlock.loadAd()
        yaSmallAdsBlock.loadAd()

        yaBigAdsBlock.isHidden = true
        yaSmallAdsBlock.isHidden = true
    }
    
    func showAd() {
        self.addSubview(yaBigAdsBlock)
        self.addSubview(yaSmallAdsBlock)
        
        NSLayoutConstraint.activate([
            yaBigAdsBlock.topAnchor.constraint(equalTo: self.topAnchor),
            yaBigAdsBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            yaSmallAdsBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yaSmallAdsBlock.topAnchor.constraint(
                equalTo: detailsViewController.view.bottomAnchor,
                constant: UIScreen.main.bounds.height*0.05)
        ])
    }
}
