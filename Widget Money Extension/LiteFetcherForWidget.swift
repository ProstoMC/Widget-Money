//
//  LiteFetcherForWidget.swift
//  Widget Money
//
//  Created by admin on 21.04.24.
//

import Foundation



class LiteFetcherForWidget {
    
    let fetcher = CurrencyFetcher()
    let universalCoinWorker = UniversalCoinWorker()
    
    var lastUpdate = "Error"
    var fiatList: [CoinUniversal] = []
    var cryptoList: [CoinUniversal] = []
    
    var newWidgetModel = WidgetModel(cellModels: [], date: "no date")

    
    var baseCoin = CoinUniversal(type: .fiat, code: "USD", name: "United States Dollar", base: "USD", rate: 1, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 2)
    
    func updateRatesFromEth(widgetModel: WidgetModel, completion: @escaping (WidgetModel) -> () ) {
        
        fiatList = universalCoinWorker.getCoinsFromDefaults(type: .fiat)
        cryptoList = universalCoinWorker.getCoinsFromDefaults(type: .crypto)
        
        //FETCHING FROM CB
        fetcher.fetchCurrencyDaily(completion: { valuteList, _ in
            var baseRate = 1.0
            //Finding Base Currency for convert from RUB
            for currency in valuteList {
                if currency.value.CharCode == self.baseCoin.code {
                    baseRate = currency.value.Value
                    break
                }
            }
            
            for currency in valuteList {
                //let name = currency.value.Name  //It is russian name
                self.updateRatesFromCB(
                    code: currency.value.CharCode,
                    rate: currency.value.Value/baseRate,
                    flow: (currency.value.Value - currency.value.Previous)/baseRate)
            }
        })
        
        //FETCHING FROM CRYPTOMARKET
        
        //Preparing Codes for request
        var coinsCodes = ""
        
        for element in fiatList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        for element in cryptoList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        
        // Request
        fetcher.updateCoinRates(base: "USD", coinCodes: coinsCodes, completion: { list in

            DispatchQueue.main.async {
                self.updateRates(json: list)
                self.newWidgetModel.date = self.lastUpdate
                for cellModel in widgetModel.cellModels {
                    let updatedCellModel = self.updateCellModel(cellModel: cellModel)
                    self.newWidgetModel.cellModels.append(updatedCellModel)
                }
                
                completion(self.newWidgetModel)
            }
        })
        
        
    }
    
    func updateCellModel(cellModel: WidgetCellModel) -> WidgetCellModel {
        var newCellModel = cellModel
        
        guard let valueCoin = returnCoin(code: cellModel.valueCode) else { return cellModel}
        guard let baseCoin = returnCoin(code: cellModel.baseCode) else { return cellModel}
        
        let rate = valueCoin.rate/baseCoin.rate
        
        let previosValue = valueCoin.rate-valueCoin.flow24Hours
        let previosBase = baseCoin.rate-baseCoin.flow24Hours
        
        let flow = (valueCoin.rate/baseCoin.rate)-(previosValue/previosBase)
        
        newCellModel.value = rate
        newCellModel.flow = flow
        
        return newCellModel
        
    }

    
//    func createCoinList(widgetModel: WidgetModel) -> [String] {
//
//        var coinList: [String] = []
//        for cellModel in widgetModel.cellModels {
//            for coinName in coinList {
//                if coinName != cellModel.valueCode {
//                    coinList.append(cellModel.valueCode)
//                }
//                if coinName != cellModel.baseCode {
//                    coinList.append(cellModel.baseCode)
//                }
//            }
//        }
//
//        return coinList
//    }
    
    
    
    
    
//    /// Call the Dog API and then download and cache the dog image
//    static func fetchRandomImage() async throws -> WidgetModel {
//
//        let id = Int.random(in: 1...100)
//        let urlstr = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/" + String(id) + ".png"
//        let url = URL(string: urlstr)!
//
//        // Download image from URL
//        let (imageData, _) = try await URLSession.shared.data(from: url)
//
//        guard let image = UIImage(data: imageData) else {
//            throw ImageFetcherError.imageDataCorrupted
//        }
//
//        return image
//    }
    
    func returnCoin(code: String) -> CoinUniversal? {
        for coin in fiatList {
            if coin.code == code {
                return coin
            }
        }
        for coin in cryptoList {
            if coin.code == code {
                return coin
            }
        }
        return nil
    }
    

}


//MARK: - ETHERNET

extension LiteFetcherForWidget {
    func updateRatesFromCB(code: String, rate: Double, flow: Double) {
        
        for i in fiatList.indices {
            if code == fiatList[i].code {
                fiatList[i].rate = rate
                fiatList[i].flow24Hours = flow
                fiatList[i].imageUrl = "https://raw.githubusercontent.com/ProstoMC/CurrencyIcons/main/" + fiatList[i].code + ".png"
                break
            }
        }
    }
    
    func updateRates(json: [String : Any]) {
        //Set previous rate in USD
        var baseRate = returnCoin(code: "USD")!.rate
        
        //Find Last Update and Base Currency for convert from USD
        if let coinsProperty = json[baseCoin.code] as? [String: Any] {
            if let properties = coinsProperty["USD"] as? [String: Any] {
                //Set rate
                if let rate = properties["PRICE"] as? Double {
                    baseRate = rate
                }
                //Set date
                if let date = properties["LASTUPDATE"] as? Int {
                    // convert Int to TimeInterval (typealias for Double)
                    let timeInterval = TimeInterval(date)
                    // create NSDate from Double (NSTimeInterval)
                    let nsDate = Date(timeIntervalSince1970: timeInterval)
   
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM HH:mm"
                    
                    lastUpdate = dateFormatter.string(from: nsDate)
                }
            }
            
        }
        
        for i in fiatList.indices {
            guard let coinsProperty = json[fiatList[i].code] as? [String: Any] else { continue }
            guard let properties = coinsProperty["USD"] as? [String: Any] else { continue }
            
            guard let rate = properties["PRICE"] as? Double else { continue }
            guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
            
            fiatList[i].rate = rate / baseRate
            fiatList[i].flow24Hours = flow / baseRate
            //fiatList[i].imageUrl = "https://www.cryptocompare.com" + imageUrl
            fiatList[i].imageUrl = "https://raw.githubusercontent.com/ProstoMC/CurrencyIcons/main/" + fiatList[i].code + ".png"
        }
        
        for i in cryptoList.indices {
            guard let coinsProperty = json[cryptoList[i].code] as? [String: Any] else { continue }
            guard let properties = coinsProperty["USD"] as? [String: Any] else { continue }
            
            guard let rate = properties["PRICE"] as? Double else { continue }
            guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
            var imageUrl = properties["IMAGEURL"] as? String ?? "Error"
            
            if imageUrl == "/media/35309345/no-image.png" { //Prefere dont have image then this image
                imageUrl = "Error"
            }
            
            cryptoList[i].rate = rate / baseRate
            cryptoList[i].flow24Hours = flow / baseRate
            cryptoList[i].imageUrl = "https://www.cryptocompare.com" + imageUrl
            cryptoList[i].logo = cryptoList[i].code
        }
    }
    
}
