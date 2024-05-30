//
//  SettingsViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation
import RxSwift
import UIKit
import StoreKit

struct SettingsCellViewModel {
    let name: String
    var value: BehaviorSubject<String>
    var imageName: String
    
    var nameLabelColor: BehaviorSubject<UIColor>
    var valueLabelColor: BehaviorSubject<UIColor>
    var backgroundColor: BehaviorSubject<UIColor>
}

protocol SettingsViewModelProtocol {
    var colorSet: AppColors { get }
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var rxAdsIsHidden: BehaviorSubject<Bool> { get }
    
    var settingsList: [SettingsCellViewModel] { get }
    var rxSettingsListUpdated: BehaviorSubject<Bool> { get }
    
    var bannerID: String { get }
    
    func changeBaseCurrency(name: String)
    func changeTheme(theme: AppTheme)
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    var rxAdsIsHidden = BehaviorSubject(value: false)
    
    var colorSet: AppColors = CoreWorker.shared.colorsWorker.returnColors()
    var rxAppThemeUpdated = BehaviorSubject(value: true)
    var bannerID: String = CoreWorker.shared.adsWorker.returnBannerID(bannerType: .settingsBannerID)
    let bag = DisposeBag()

    var settingsList: [SettingsCellViewModel] = []
    var rxSettingsListUpdated = BehaviorSubject(value: false)
    
    init() {
        settingsList = createSettingsList()
        subscribing()
    }
    
    private func subscribing() {
        
        //Subscribe to Coin List
        CoreWorker.shared.coinList.rxRateUpdated.subscribe { _ in
            self.settingsList[0].value.onNext(CoreWorker.shared.coinList.baseCoin.code)
        }.disposed(by: bag)
        
        //Subscribe to Colors worker
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe { _ in
            //Update colors in VC
            self.changeColorSet()
            self.rxAppThemeUpdated.onNext(true)
            
            var valueName = ""
            switch CoreWorker.shared.colorsWorker.returnAppTheme() {
            case .dark: valueName = "Dark".localized()
            case .light: valueName = "Light".localized()
            case .system: valueName = "System".localized()
            }
            //Change name of theme
            self.settingsList[1].value.onNext(valueName)
        }.disposed(by: bag)
        
        
        //Subscribe to adsWorker
        CoreWorker.shared.adsWorker.adsIsHidden.subscribe(onNext: { isHidden in
            self.rxAdsIsHidden.onNext(isHidden)
        }).disposed(by: bag)
        
        
        //Subscribe to Purchase worker
            //After getting purchaces - add it to Settings list and update view
        CoreWorker.shared.purchaseWorker.rxProductsFetchedFlag.subscribe(onNext: { flag in
            if flag {
                let products = CoreWorker.shared.purchaseWorker.returnProducts()
                products.forEach({ product in
                    self.settingsList.append(self.createPurchaseSettings(product: product))
                })
                self.rxSettingsListUpdated.onNext(true)
            }
        }).disposed(by: bag)

    }

    func changeBaseCurrency(name: String) {
        CoreWorker.shared.coinList.setBaseCoin(newCode: name)
    }
    
    func changeTheme(theme: AppTheme) {
        if theme != CoreWorker.shared.colorsWorker.returnAppTheme() {
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: theme)
        }
    }

}

extension SettingsViewModel {
    private func createSettingsList() -> [SettingsCellViewModel] {
        var list: [SettingsCellViewModel] = []
        //Add base coin form CoinList
        list.append(createBaseCurrencySettings())
        list.append(createThemeSettigs())
        
        return list
    }
    
    private func createBaseCurrencySettings() -> SettingsCellViewModel {
        return SettingsCellViewModel(
            name: "Base currency".localized(),
            value: BehaviorSubject(value: CoreWorker.shared.coinList.baseCoin.code),
            imageName: "SettingsCurrency",
            nameLabelColor: BehaviorSubject(value: colorSet.mainText),
            valueLabelColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets)
        )
    }
    private func createThemeSettigs() -> SettingsCellViewModel {
        var valueName = ""
        
        switch CoreWorker.shared.colorsWorker.returnAppTheme() {
        case .dark: valueName = "Dark".localized()
        case .light: valueName = "Light".localized()
        case .system: valueName = "System".localized()
        }
        
        return SettingsCellViewModel(
            name: "App theme".localized(),
            value: BehaviorSubject(value: valueName),
            imageName: "SettingsTheme",
            nameLabelColor: BehaviorSubject(value: colorSet.mainText),
            valueLabelColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets)
        )
    }
    private func createPurchaseSettings(product: SKProduct) -> SettingsCellViewModel {
        return SettingsCellViewModel(
            name: product.localizedDescription,
            value: BehaviorSubject(value: formatPrice(product: product)),
            imageName: product.productIdentifier,
            nameLabelColor: BehaviorSubject(value: colorSet.mainText),
            valueLabelColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets)
        )
    }
    
    private func formatPrice(product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? "No data"
    }
    
}

extension SettingsViewModel {
    private func changeColorSet() {
        colorSet = CoreWorker.shared.colorsWorker.returnColors()
        
        for i in settingsList.indices {
            settingsList[i].nameLabelColor.onNext(colorSet.mainText)
            settingsList[i].valueLabelColor.onNext(colorSet.settingsText)
            settingsList[i].backgroundColor.onNext(colorSet.backgroundForWidgets)
        }
        
    }
}
