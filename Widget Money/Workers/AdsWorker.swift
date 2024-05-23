//
//  AdsWorker.swift
//  Widget Money
//
//  Created by admin on 09.05.24.
//

import Foundation
import RxSwift

enum bannerIDs: String {
    case mainBigBannerID = "ca-app-pub-7946769692194601/4118930482"
    case mainSmallBannerID = "ca-app-pub-7946769692194601/3927358799"
    case settingsBannerID = "ca-app-pub-7946769692194601/4341308255"
    case testID = "ca-app-pub-3940256099942544/2435281174"
}

protocol AdsWorkerProtocol {
    var testmode: Bool { get }
    var adsIsHidden: BehaviorSubject<Bool> { get }
    var price: BehaviorSubject<String> { get }
    
    func returnBannerID(bannerType: bannerIDs) -> String
}



class AdsWorker: AdsWorkerProtocol {
    
    let testmode = true
    
    var adsIsHidden = BehaviorSubject(value: false)
    var price = BehaviorSubject(value: "No data")
    
    let defaults = UserDefaults.standard
    

    
    init() {
        adsIsHidden.onNext(getAdsStatusFromDefaults())
        //adsIsHidden.onNext(true) //For tests
    }
    
    func returnBannerID(bannerType: bannerIDs) -> String {
        if testmode {
            return bannerIDs.testID.rawValue
        }
        else {
            return bannerType.rawValue
        }
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
