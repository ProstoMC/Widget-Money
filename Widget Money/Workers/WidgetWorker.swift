//
//  WidgetWorker.swift
//  Currency Widget
//
//  Created by  slm on 02.02.2024.
//

import Foundation
import SwiftUI
import WidgetKit
import RxSwift

protocol WidgetWorkerProtocol {
    
}

class WidgetWorker: WidgetWorkerProtocol {
    let bag = DisposeBag()
    
    @AppStorage("WidgetModel", store: UserDefaults(suiteName: "group.com.sloniklm.WidgetMoney"))
    var widgetData = Data()
    
    let pairModule: CoinPairProtocol
    let coinList: CoinListProtocol
    
    //var widgetModels: [WidgetCellModel] = [] //New synchronised models
    var widgetModel = WidgetModel(cellModels: [], date: "nil")
    
    init(pairModule: CoinPairProtocol, coinList: CoinListProtocol) {
        self.pairModule = pairModule
        self.coinList = coinList
        
        subscribing()
    }
    
    func subscribing() {
        pairModule.rxPairListCount.subscribe { _ in
            self.createWidgetModelsFromFavoritePairs()
        }.disposed(by: bag)
        
        coinList.rxRateUpdated.subscribe{ _ in
            self.createWidgetModelsFromFavoritePairs()
        }.disposed(by: bag)
    }
    
    func createWidgetModelsFromFavoritePairs() {
        widgetModel.cellModels = []
        
        for i in pairModule.pairList.indices {
            addModelToNewList(pair: pairModule.pairList[i], index: i)
        }
    }
    
    
    func addModelToNewList(pair: CoinPair, index: Int) {
        
        var valueImageData: Data? = coinList.returnCoin(code: pair.valueCode)?.imageData
        var baseImageData: Data? = coinList.returnCoin(code: pair.baseCode)?.imageData
        
        if valueImageData == nil || baseImageData == nil {
            
            let group = DispatchGroup()
            
            group.enter()
            
            fetchImage(stringUrl: coinList.returnCoin(code: pair.valueCode)?.imageUrl ?? "", completion: { fetchedImageData in
                DispatchQueue.main.async {
                    valueImageData = fetchedImageData
                    self.coinList.addImageData(code: pair.valueCode, data: fetchedImageData!)
                    group.leave()
                }
                
            })
            group.enter()
            
            fetchImage(stringUrl: coinList.returnCoin(code: pair.baseCode)?.imageUrl ?? "", completion: { fetchedImageData in
                DispatchQueue.main.async {
                    baseImageData = fetchedImageData
                    self.coinList.addImageData(code: pair.baseCode, data: fetchedImageData!)
                    group.leave()
                }
            })
            
            group.notify(queue: .main) {
                
                guard let model = self.createWidgetCellModel(index: index, valueCode: pair.valueCode, baseCode: pair.baseCode, imageData: valueImageData, baseImageData: baseImageData) else { return }
                self.widgetModel.cellModels.append(model)
                self.save()
            }
        }
        
        else {
            guard let model = self.createWidgetCellModel(
                index: index,
                valueCode: pair.valueCode,
                baseCode: pair.baseCode,
                imageData: valueImageData,
                baseImageData: baseImageData
            ) else { return }
            self.widgetModel.cellModels.append(model)
            self.save()
        }
        
        
    }
    
    func createWidgetCellModel(index: Int, valueCode: String, baseCode: String, imageData: Data?, baseImageData: Data?) -> WidgetCellModel? {
        //print("Creating Cell model")
        guard let valueCurrency = coinList.returnCoin(code: valueCode) else {
            print("Value currency \(valueCode) didnt find")
            return nil
            
        }
        guard let baseCurrency = coinList.returnCoin(code: baseCode) else {
            print("Base currency didnt find")
            return nil }
        let rate = valueCurrency.rate/baseCurrency.rate
        
        let previosRate = valueCurrency.rate-valueCurrency.flow24Hours
        let previosBase = baseCurrency.rate-baseCurrency.flow24Hours
        
        let flow = (valueCurrency.rate/baseCurrency.rate)-(previosRate/previosBase)
        
        return WidgetCellModel (
            id: index,
            valueCode: valueCurrency.code,
            baseCode: baseCurrency.code,
            value: rate,
            flow: flow,
            valueName: valueCurrency.name,
            baseSymbol: baseCurrency.logo,
            imageData: imageData,
            baseImageData: baseImageData
            
        )
    }
    
    func save() {
        //printList()
        widgetModel.date = coinList.lastUpdate
        
        let sortedModels = widgetModel.cellModels.sorted(by: { $0.id < $1.id } )
        widgetModel.cellModels = sortedModels
        guard let data = try? JSONEncoder().encode(widgetModel) else { return }
        widgetData = data
        //print("Data saved")
        WidgetCenter.shared.reloadTimelines(ofKind: "Widget_Money_Extension")
    }
    
    func printList() {
        print("==WIDGET MODELS==")
        for model in widgetModel.cellModels {
            var exist = "Image EXISTS"
            if model.imageData == nil {
                exist = "Image doesn't EXIST"
            }
            print("\(model.valueCode) - \(model.baseCode) - \(exist)")
            
        }
    }
    
    
    func fetchImage(stringUrl: String, completion: @escaping (Data?) -> ()) {
        
        guard let url = URL(string: "\(stringUrl)") else {
            //print ("URL is wrong")
            return
        }
        //print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    
}


