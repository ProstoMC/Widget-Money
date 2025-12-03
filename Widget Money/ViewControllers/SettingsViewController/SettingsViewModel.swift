//
//  SettingsViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation
import Combine
import UIKit
import StoreKit

class SettingsCellViewModel {
    init(
        name: String,
        value: String,
        imageName: String,
        productID: String? = nil,
        nameLabelColor: UIColor,
        valueLabelColor: UIColor,
        backgroundColor: UIColor,
        imageColor: UIColor) {
        
            self.name = name
            self.value = value
            self.imageName = imageName
            self.productID = productID
            self.nameLabelColor = nameLabelColor
            self.valueLabelColor = valueLabelColor
            self.backgroundColor = backgroundColor
            self.imageColor = imageColor
    }
    
    let name: String
    @Published var value: String
    let imageName: String
    var productID: String? = nil
        
    @Published var nameLabelColor: UIColor
    @Published var valueLabelColor: UIColor
    @Published var backgroundColor: UIColor
    @Published var imageColor: UIColor
}

protocol SettingsViewModelProtocol {
    var colorSet: AppColors { get }
    var rxAppThemeUpdated: Bool { get }
    var rxAdsIsHidden: Bool { get }
    
    var settingsList: [SettingsCellViewModel] { get }
    var rxSettingsListUpdated: Bool { get }
    
    var bannerID: String { get }
    
    func changeBaseCurrency(name: String)
    func changeTheme(theme: AppTheme)
    func returnProduct(id: String) -> Product?
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    @Published var rxAdsIsHidden: Bool = false
    
    var colorSet: AppColors = CoreWorker.shared.colorsWorker.returnColors()
    @Published var rxAppThemeUpdated: Bool = true
    var bannerID: String = CoreWorker.shared.adsWorker.returnYABannerID(bannerType: .yaSettingsBannerID)
    
    private var cancellables = Set<AnyCancellable>()

    var settingsList: [SettingsCellViewModel] = []
    @Published var rxSettingsListUpdated: Bool = false
    
    init() {
        settingsList = createSettingsList()
        subscribing()
    }
    
    private func subscribing() {
        
        //Subscribe to Coin List
        CoreWorker.shared.coinList.rxRateUpdated.sink { _ in
            self.settingsList[0].value = CoreWorker.shared.coinList.baseCoin.code
        }.store(in: &cancellables)
        
        //Subscribe to Colors worker
        CoreWorker.shared.colorsWorker.$rxAppThemeUpdated.sink { _ in
            //Update colors in VC
            self.changeColorSet()
            self.rxAppThemeUpdated = true
            
            var valueName = ""
            switch CoreWorker.shared.colorsWorker.returnAppTheme() {
            case .dark: valueName = "Dark".localized()
            case .light: valueName = "Light".localized()
            case .system: valueName = "System".localized()
            }
            //Change name of theme
            self.settingsList[1].value = valueName
        }.store(in: &cancellables)
        
        
        //Subscribe to adsWorker
        CoreWorker.shared.purchaseWorker.$rxAdsIsHidden.sink { isHidden in
            self.rxAdsIsHidden = isHidden
        }.store(in: &cancellables)
        
        
        //Subscribe to Purchase worker
            //After getting purchaces - add it to Settings list and update view
        CoreWorker.shared.purchaseWorker.$rxProductsFetchedFlag.sink { flag in
            if flag {
                let products = CoreWorker.shared.purchaseWorker.returnProducts()
                products.forEach({ product in
                    self.settingsList.append(self.createPurchaseSettings(product: product))
                })
                self.rxSettingsListUpdated = true
            }
        }.store(in: &cancellables)

    }

    func changeBaseCurrency(name: String) {
        CoreWorker.shared.coinList.setBaseCoin(newCode: name)
    }
    
    func changeTheme(theme: AppTheme) {
        if theme != CoreWorker.shared.colorsWorker.returnAppTheme() {
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: theme)
        }
    }
    
    func returnProduct(id: String) -> Product? {
       return CoreWorker.shared.purchaseWorker.returnProduct(productID: id)
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
            value: CoreWorker.shared.coinList.baseCoin.code,
            imageName: "dollarsign.circle.fill",
            nameLabelColor: colorSet.mainText,
            valueLabelColor: colorSet.secondText,
            backgroundColor: colorSet.backgroundForWidgets,
            imageColor: colorSet.closingLine
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
            value: valueName,
            imageName: "circle.lefthalf.filled.inverse",
            nameLabelColor: colorSet.mainText,
            valueLabelColor: colorSet.secondText,
            backgroundColor: colorSet.backgroundForWidgets,
            imageColor: colorSet.closingLine
        )
    }
    
    private func createPurchaseSettings(product: Product) -> SettingsCellViewModel {
        
        //Check has product already purchased. If it is -> change name for "Purchased"
        var value = product.displayPrice
        if CoreWorker.shared.purchaseWorker.isProductPurchased(product.id) {
            value = "Purchased".localized()
        }
        //Subscribe for purchasing for changeing name
        CoreWorker.shared.purchaseWorker.$rxProductPurchased.sink { _ in
            if CoreWorker.shared.purchaseWorker.isProductPurchased(product.id) {
                value = "Purchased".localized()
            }
        }.store(in: &cancellables)
        
        
        
        return SettingsCellViewModel (
            name: product.displayName.localized(),
            value: value,
            imageName: "xmark.circle.fill",
            productID: product.id,
            nameLabelColor: colorSet.mainText,
            valueLabelColor: colorSet.secondText,
            backgroundColor: colorSet.backgroundForWidgets,
            imageColor: colorSet.closingLine
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
            settingsList[i].nameLabelColor = colorSet.mainText
            settingsList[i].valueLabelColor = colorSet.settingsText
            settingsList[i].backgroundColor = colorSet.backgroundForWidgets
            settingsList[i].imageColor = colorSet.closingLine
        }
        
    }
}
