//
//  AdsWorker.swift
//  Widget Money
//
//  Created by admin on 09.05.24.
//

import Foundation
import RxSwift
import UIKit

enum bannerIDs: String {
    case mainBigBannerID = "ca-app-pub-7946769692194601/4118930482"
    case mainSmallBannerID = "ca-app-pub-7946769692194601/3927358799"
    case settingsBannerID = "ca-app-pub-7946769692194601/4341308255"
    case testID = "ca-app-pub-3940256099942544/2435281174"
    
    case yaSettingsBannerID = "R-M-11757746-1"
    case yaMainBigBannerID = "R-M-11757746-3"
    case yaMainSmallBannerID = "R-M-11757746-4"
    case yatestID = "demo-banner-yandex"
}

protocol AdsWorkerProtocol {
    var testmode: Bool { get }
    var adsIsHidden: BehaviorSubject<Bool> { get }
    
    func setBottomAnchor(anchor: NSLayoutYAxisAnchor)
    func returnBottomAnchor() -> NSLayoutYAxisAnchor?
    
    func returnBannerID(bannerType: bannerIDs) -> String
    func returnYABannerID(bannerType: bannerIDs) -> String
    
}

class AdsWorker: AdsWorkerProtocol {

    let testmode = false
    
    var adsIsHidden = BehaviorSubject(value: false)
    var bottomAnchor: NSLayoutYAxisAnchor? = nil
    
    let defaults = UserDefaults.standard
    
     init() {
        adsIsHidden.onNext(getAdsStatusFromDefaults())
        //adsIsHidden.onNext(true) //For tests
    }
    
    func returnYABannerID(bannerType: bannerIDs) -> String {
        if testmode {
            return bannerIDs.yatestID.rawValue
        }
        else {
            return bannerType.rawValue
        }
    }
    
    func returnBannerID(bannerType: bannerIDs) -> String {
        if testmode {
            return bannerIDs.testID.rawValue
        }
        else {
            return bannerType.rawValue
        }
    }
    
    func setBottomAnchor(anchor: NSLayoutYAxisAnchor) {
        bottomAnchor = anchor
    }
    func returnBottomAnchor() -> NSLayoutYAxisAnchor? {
        return bottomAnchor
    }
    
}

extension AdsWorker {
    
    func saveAdsStatusToDefaults() {
        defaults.set(adsIsHidden, forKey: "adsIsHidden")
    }
    func getAdsStatusFromDefaults() -> Bool {
        return defaults.bool(forKey: "adsIsHidden") // It will be false if doesn't exist
    }
    
}
