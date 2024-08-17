//
//  LiteFetcherForWidget.swift
//  Widget Money
//
//  Created by admin on 21.04.24.
//

import Foundation



class LiteFetcherForWidget {
    
    let fetcher = CurrencyFetcher()
    var coinList: [CoinUniversal] = []
    var newWidgetModel = WidgetModel(cellModels: [], date: "no date")
    
    
    func updateFromBackend(widgetModel: WidgetModel, completion: @escaping (WidgetModel) -> ()) {
        fetcher.fetchCoinsFromBackend(completion: { coins, lastUpdate in
            //If we din't get data - return old model
            if lastUpdate == "Error" {
                print("End with error")
                completion(widgetModel)
                return
            }
            
            self.coinList = coins // We will update rates in func: UpdateCellModel
            
            self.newWidgetModel.date = lastUpdate
            
            print("GOT DATA: \(lastUpdate)")
            
            //Update each modell in widget list
            for cellModel in widgetModel.cellModels {
                let updatedCellModel = self.updateCellModel(cellModel: cellModel)
                self.newWidgetModel.cellModels.append(updatedCellModel)
            }
            print("GOT DATA: \(self.newWidgetModel.date)")
            completion(self.newWidgetModel)
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

    
    func returnCoin(code: String) -> CoinUniversal? {
        for coin in coinList {
            if coin.code == code {
                return coin
            }
        }
        return nil
    }
}
