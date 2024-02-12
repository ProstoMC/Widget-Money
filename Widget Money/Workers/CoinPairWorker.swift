//
//  CoinPairWorker.swift
//  Currency Widget
//
//  Created by  slm on 19.01.2024.
//

import Foundation
import RxSwift

struct CoinPair: Codable {
    var valueCode: String
    var baseCode: String
    var colorIndex: Int?
}


protocol CoinPairProtocol {
    var pairList: [CoinPair] { get }
    
    var rxPairListCount: BehaviorSubject<Int> { get }
    
    func addNewPair(valueCode: String, baseCode: String, colorIndex: Int?)
    func deletePair(index: Int)
    func deletePair(valueCode: String, baseCode: String)
    func reorderPair(from: Int, to: Int)
    func checkIsExist(valueCode: String, baseCode: String) -> Bool
}

class CoinPairWorker {
    var pairList: [CoinPair] = []
    var rxPairListCount = BehaviorSubject(value: 0)
    let bag = DisposeBag()
    
    init() {
        createPairList()
        rxSubscribing()
    }
    
    
    func createPairList() {
        //Get pairs
        pairList = getPairsFromDefaults()
        if pairList.isEmpty {
            pairList = [CoinPair(valueCode: "USD", baseCode: "RUB", colorIndex: 0)]
        }
        rxPairListCount.onNext(pairList.count)
    }
    
    func rxSubscribing() {
        rxPairListCount.subscribe({_ in
            self.saveToDefaults()
            self.printList()
        }).disposed(by: bag)
    }
    
    func printList() {
        for (i, pair) in pairList.enumerated() {
            print("\(pair.valueCode) : \(pair.baseCode) : \(i)")
        }
    }
    
    
}


//MARK: - PROTOCOL
extension CoinPairWorker: CoinPairProtocol {

    func addNewPair(valueCode: String, baseCode: String, colorIndex: Int?) {
        var position = pairList.count
        if position > 2 { position = 2 }
        let pair = CoinPair(valueCode: valueCode, baseCode: baseCode, colorIndex: colorIndex)
        pairList.insert(pair, at: position)
        rxPairListCount.onNext(pairList.count)
    }
    
    func deletePair(index: Int) {
        pairList.remove(at: index)
        rxPairListCount.onNext(pairList.count)
    }
    
    func deletePair(valueCode: String, baseCode: String) {
        var deleteIndex = -1
        for (index, pair) in pairList.enumerated(){
            if pair.valueCode == valueCode && pair.baseCode == baseCode {
                deleteIndex = index
            }
        }
        if deleteIndex >= 0 {
            print("Delete index = \(deleteIndex)")
            pairList.remove(at: deleteIndex)
            rxPairListCount.onNext(pairList.count)
        }
        
    }
    
    func reorderPair(from: Int, to: Int) {
        let pair = pairList.remove(at: from)
        pairList.insert(pair, at: to)
        rxPairListCount.onNext(pairList.count)
    }
    
    func checkIsExist(valueCode: String, baseCode: String) -> Bool {
        var isExist = false
        for pair in pairList {
            if pair.valueCode == valueCode && pair.baseCode == baseCode {
                isExist = true
            }
        }
        return isExist
    }
    
}

//MARK: - USER DEFAULTS
extension CoinPairWorker {
    
    func saveToDefaults() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        if let pairs = try? encoder.encode(pairList) {
            defaults.set(pairs, forKey: "CoinPairList")
            print("--Coin pairs was saved--")
        }
    }
    
    
    func getPairsFromDefaults() -> [CoinPair] {
        let defaults = UserDefaults.standard
        var list: [CoinPair] = []
        
        if let savedData = defaults.object(forKey: "CoinPairList") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedList = try decoder.decode([CoinPair].self, from: savedData)
                list = savedList
            }
            catch { list = [] }
        }
        return list
    }
}
