//
//  UniversalCoinWorker.swift
//  Currency Widget
//
//  Created by macSlm on 11.01.2024.
//

import Foundation
import RxSwift

protocol CoinListProtocol {
    var baseCoin: CoinUniversal { get }
    var lastUpdate: String { get }
    var fiatList: [CoinUniversal] { get }
    var cryptoList: [CoinUniversal] { get }
    var rxRateUpdated: BehaviorSubject<Bool> { get }
    
    func updateRatesFromEth()
    func returnCoin(code: String) -> CoinUniversal?
    func setBaseCoin(newCode: String)
    func addImageData(code: String, data: Data)
}



class UniversalCoinWorker {
    var rxRateUpdated = BehaviorSubject(value: false)

    var baseCoin = CoinUniversal(type: .fiat, code: "USD", name: "United States Dollar", base: "USD", rate: 1, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 2)
    var lastUpdate = "Error"
    var fiatList: [CoinUniversal] = []
    var cryptoList: [CoinUniversal] = []
    
    let fetcher = CurrencyFetcher()
    let defaults = UserDefaults.standard
    let bag = DisposeBag()
    
    init() {
        rxSubscribing()
        getFromDefaulst()
        updateRatesFromEth()
        
    }
    
    func rxSubscribing() {
        rxRateUpdated.subscribe{ success in
            if success {
                self.saveCoinsToDefaults()
                self.fiatList.forEach({ coin in
                })
            }
        }.disposed(by: bag)
    }
    
    func returnFiatList() -> [CoinUniversal] {
        return fiatList
    }
    
    func returnBaseCode() -> String {
        return baseCoin.code
    }
    
    func addImageData(code: String, data: Data) {
        for i in fiatList.indices {
            if fiatList[i].code == code {
                fiatList[i].imageData = data
                return
            }
        }
        for i in cryptoList.indices {
            if cryptoList[i].code == code {
                cryptoList[i].imageData = data
                return
            }
        }
    }
}

extension UniversalCoinWorker: CoinListProtocol {
    
    func updateRatesFromEth() {
        updateRatesFromBackend()
    }
    
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
    
    func setBaseCoin(newCode: String) {
        guard let newBaseCoin = returnCoin(code: newCode) else { return }
        let ratio = newBaseCoin.rate / baseCoin.rate
        for i in fiatList.indices {
            fiatList[i].rate = fiatList[i].rate / ratio
            fiatList[i].flow24Hours = fiatList[i].flow24Hours / ratio
        }
        for i in cryptoList.indices {
            cryptoList[i].rate = cryptoList[i].rate / ratio
            cryptoList[i].flow24Hours = cryptoList[i].flow24Hours / ratio
        }
        
        baseCoin = returnCoin(code: newCode)! // Get updated values. And we've checked existing in first line
        rxRateUpdated.onNext(true)
    }
    
     
    
}



//MARK: - PERSONAL BACKEND
extension UniversalCoinWorker {
    func updateRatesFromBackend() {
        fetcher.fetchCoinsFromBackend(completion: { coins, date in
            if coins.count < 1 { return } //Check what we have a new coins
            self.lastUpdate = date //Update date
            
            //find base coin rate in USD
            var baseCoinRate = self.baseCoin.rate
            for coin in coins {
                if coin.code == self.baseCoin.code {
                    baseCoinRate = coin.rate
                    break
                }
            }
            
            var newFiat: [CoinUniversal] = []
            var newCrypto: [CoinUniversal] = []
            
            coins.forEach({ coin in
                
                //Update rate with baseCoin Rate in USD
                var newCoin = coin
                newCoin.rate = coin.rate/baseCoinRate
                newCoin.flow24Hours = coin.flow24Hours/baseCoinRate
                
                if coin.type == .fiat {
                    newFiat.append(newCoin)
                    // print("FIAT -- \(coin.name)")
                } else {
                    newCrypto.append(newCoin)
                    //print("CRYPTO -- \(coin.name)")
                }
                
                //print("\(newCoin.code) : \(newCoin.flow24Hours)")
            })
            
            self.fiatList = newFiat
            self.cryptoList = newCrypto
            self.sortCoins()
            self.rxRateUpdated.onNext(true)
            
        })
    }
    
    func sortCoins() {
        fiatList.sort(by: {$0.code < $1.code})
        cryptoList.sort(by: {$0.code < $1.code})
        
        //Place btc, eth, usd, cny, eur to top of lists
        
        placeToFirst(code: "CNY", typeOfCoin: .fiat)
        placeToFirst(code: "EUR", typeOfCoin: .fiat)
        placeToFirst(code: "USD", typeOfCoin: .fiat)
        
        placeToFirst(code: "ETH", typeOfCoin: .crypto)
        placeToFirst(code: "BTC", typeOfCoin: .crypto)
        
        
    }
    
    private func placeToFirst(code: String, typeOfCoin: TypeOfCoin) {
        
        if typeOfCoin == .fiat {
            for (index, coin) in fiatList.enumerated() {
                if coin.code == code {
                    let tmpCoin = coin
                    fiatList.remove(at: index)
                    fiatList.insert(tmpCoin, at: 0)
                    return
                }
            }
        } else {
            for (index, coin) in cryptoList.enumerated() {
                if coin.code == code {
                    let tmpCoin = coin
                    cryptoList.remove(at: index)
                    cryptoList.insert(tmpCoin, at: 0)
                    return
                }
            }
        }
        
    }
}

// MARK: - USER DEFAULTS
extension UniversalCoinWorker {

    func saveCoinsToDefaults() {
        let encoder = JSONEncoder()
        
        if let fiats = try? encoder.encode(fiatList) {
            defaults.set(fiats, forKey: TypeOfCoin.fiat.rawValue)
            print("--Fiats was saved--")
        }
        if let coins = try? encoder.encode(cryptoList) {
            defaults.set(coins, forKey: TypeOfCoin.crypto.rawValue)
            print("--Coins was saved--")
        }
        if let base = try? encoder.encode(baseCoin){
            defaults.set(base, forKey: "baseCoin")
            print("--Base coin was saved--")
        }
        defaults.set(lastUpdate, forKey: "lastUpdate")
    }
    
    func getFromDefaulst() {
        //Get coins
        fiatList = getCoinsFromDefaults(type: .fiat)
        if fiatList.isEmpty {
            fiatList = createFiatList()
        }
        cryptoList = getCoinsFromDefaults(type: .crypto)
        if cryptoList.isEmpty {
            cryptoList = createCryptoList()
        }
        //Get baseCoin
        let coin = getBaseCoinFromDefaults()
        if coin == nil {
            setBaseCoin(newCode: "USD")
        } else {
            baseCoin = coin!
        }
        //Get lastUpdate
        let date = getLastUpdateFromDefaults()
        if date == nil {
            lastUpdate = "Error"
        } else {
            lastUpdate = date!
        }
        
        rxRateUpdated.onNext(true)
    }
    
    func getCoinsFromDefaults(type: TypeOfCoin) -> [CoinUniversal] {
        
        var list: [CoinUniversal] = []
        
        if let savedData = defaults.object(forKey: type.rawValue) as? Data {
            let decoder = JSONDecoder()
            do {
                let savedList = try decoder.decode([CoinUniversal].self, from: savedData)
                list = savedList
            }
            catch { list = [] }
        }
        return list
    }
    func getBaseCoinFromDefaults() -> CoinUniversal? {
        
        if let savedData = defaults.object(forKey: "baseCoin") as? Data {
            let decoder = JSONDecoder()
            do {
                let coin = try decoder.decode(CoinUniversal.self, from: savedData)
                return coin
            }
            catch { return nil }
        }
        return nil
    }
    func getLastUpdateFromDefaults() -> String? {
        return defaults.object(forKey: "lastUpdate") as? String
    }
    
}

 //MARK: - DEFAULT LISTS
extension UniversalCoinWorker {
    private func createFiatList() -> [CoinUniversal] {
        return [
            CoinUniversal(type: .fiat, code: "RUB", name: "Russian Ruble", base: "USD", rate: 0, flow24Hours: 0, logo: "₽", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "AUD", name: "Australian Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "A$", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "AZN", name: "Azerbaijani Manat", base: "USD", rate: 0, flow24Hours: 0, logo: "₼", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "GBP", name: "British Pound Sterling", base: "USD", rate: 0, flow24Hours: 0, logo: "£", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "AMD", name: "Armenian Dram", base: "USD", rate: 0, flow24Hours: 0, logo: "֏", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "BYN", name: "Belarusian Ruble", base: "USD", rate: 0, flow24Hours: 0, logo: "Br", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "BGN", name: "Bulgarian Lev", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "BRL", name: "Brazilian Real", base: "USD", rate: 0, flow24Hours: 0, logo: "R$", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "HUF", name: "Hungarian Forint", base: "USD", rate: 0, flow24Hours: 0, logo: "Ft", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "VND", name: "Vietnamese Dong", base: "USD", rate: 0, flow24Hours: 0, logo: "₫", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "HKD", name: "Hong Kong Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "₫", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "GEL", name: "Georgian Lari", base: "USD", rate: 0, flow24Hours: 0, logo: "₾", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "DKK", name: "Danish Krone", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "AED", name: "UAE Dirham", base: "USD", rate: 0, flow24Hours: 0, logo: "د.إ", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "USD", name: "United States Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "EUR", name: "Euro", base: "USD", rate: 0, flow24Hours: 0, logo: "€", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "EGP", name: "Egyptian Pound", base: "USD", rate: 0, flow24Hours: 0, logo: "E£", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "INR", name: "Indian Rupee", base: "USD", rate: 0, flow24Hours: 0, logo: "₹", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "IDR", name: "Indonesian Rupiah", base: "USD", rate: 0, flow24Hours: 0, logo: "Rp", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "KZT", name: "Kazakhstani Tenge", base: "USD", rate: 0, flow24Hours: 0, logo: "₸", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "CAD", name: "Canadian Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "QAR", name: "Qatari Rial", base: "USD", rate: 0, flow24Hours: 0, logo: "﷼", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "KGS", name: "Kyrgystani Som", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "CNY", name: "Chinese Yuan", base: "USD", rate: 0, flow24Hours: 0, logo: "¥", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "MDL", name: "Moldovan leu", base: "USD", rate: 0, flow24Hours: 0, logo: "L", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "NZD", name: "New Zealand Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "NZ$", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "NOK", name: "Norwegian Krone", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "PLN", name: "Polish Zloty", base: "USD", rate: 0, flow24Hours: 0, logo: "zł", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "RON", name: "Romanian Leu", base: "USD", rate: 0, flow24Hours: 0, logo: "RON", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "XDR", name: "Special Drawing Rights", base: "USD", rate: 0, flow24Hours: 0, logo: "XDR", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "SGD", name: "Singapore dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "S$", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "TJS", name: "Tajikistani somoni", base: "USD", rate: 0, flow24Hours: 0, logo: "TJS", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "THB", name: "Thai baht", base: "USD", rate: 0, flow24Hours: 0, logo: "฿", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "TRY", name: "Turkish Lira", base: "USD", rate: 0, flow24Hours: 0, logo: "₺", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "TMT", name: "Turkmenistani Manat", base: "USD", rate: 0, flow24Hours: 0, logo: "T", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "UZS", name: "Uzbekistan Som", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "UAH", name: "Ukranian Hryvnia", base: "USD", rate: 0, flow24Hours: 0, logo: "₴", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "CZK", name: "Czech Koruna", base: "USD", rate: 0, flow24Hours: 0, logo: "Kč", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "SEK", name: "Swedish Krona", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "CHF", name: "Swiss Franc", base: "USD", rate: 0, flow24Hours: 0, logo: "₣", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "RSD", name: "Serbian Dinar", base: "USD", rate: 0, flow24Hours: 0, logo: "РСД", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "ZAR", name: "South African Rand", base: "USD", rate: 0, flow24Hours: 0, logo: "R", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "KRW", name: "Korean Won", base: "USD", rate: 0, flow24Hours: 0, logo: "₩", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "JPY", name: "Japanese Yen", base: "USD", rate: 0, flow24Hours: 0, logo: "¥", imageUrl: "", colorIndex: 3),
        ]
    }
    
    private func createCryptoList() -> [CoinUniversal] {
        return [
            CoinUniversal(type: .crypto, code: "BTC", name: "Bitcoin", base: "USD", rate: 0, flow24Hours: 0, logo: "BTC", imageUrl: "www.cryptocompare.com/media/37746251/btc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ETH", name: "Ethereum", base: "USD", rate: 0, flow24Hours: 0, logo: "ETH", imageUrl: "www.cryptocompare.com/media/37746238/eth.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SOL", name: "Solana", base: "USD", rate: 0, flow24Hours: 0, logo: "SOL", imageUrl: "www.cryptocompare.com/media/37747734/sol.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "XRP", name: "XRP", base: "USD", rate: 0, flow24Hours: 0, logo: "XRP", imageUrl: "www.cryptocompare.com/media/38553096/xrp.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ARB", name: "Arbitrum", base: "USD", rate: 0, flow24Hours: 0, logo: "ARB", imageUrl: "www.cryptocompare.com/media/44081950/arb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "USDC", name: "USD Coin", base: "USD", rate: 0, flow24Hours: 0, logo: "USDC", imageUrl: "www.cryptocompare.com/media/34835941/usdc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "FDUSD", name: "First Digital USD", base: "USD", rate: 0, flow24Hours: 0, logo: "FDUSD", imageUrl: "www.cryptocompare.com/media/44154091/fdusd.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "DOGE", name: "Dogecoin", base: "USD", rate: 0, flow24Hours: 0, logo: "DOGE", imageUrl: "www.cryptocompare.com/media/37746339/doge.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "USDT", name: "Tether", base: "USD", rate: 0, flow24Hours: 0, logo: "USDT", imageUrl: "www.cryptocompare.com/media/37746338/usdt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "AVAX", name: "Avalanche", base: "USD", rate: 0, flow24Hours: 0, logo: "AVAX", imageUrl: "www.cryptocompare.com/media/43977160/avax.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "OP", name: "Optimism", base: "USD", rate: 0, flow24Hours: 0, logo: "OP", imageUrl: "www.cryptocompare.com/media/40219338/op.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ADA", name: "Cardano", base: "USD", rate: 0, flow24Hours: 0, logo: "ADA", imageUrl: "www.cryptocompare.com/media/37746235/ada.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BNB", name: "Binance Coin", base: "USD", rate: 0, flow24Hours: 0, logo: "BNB", imageUrl: "www.cryptocompare.com/media/40485170/bnb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "MATIC", name: "Polygon", base: "USD", rate: 0, flow24Hours: 0, logo: "MATIC", imageUrl: "www.cryptocompare.com/media/37746047/matic.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LINK", name: "Chainlink", base: "USD", rate: 0, flow24Hours: 0, logo: "LINK", imageUrl: "www.cryptocompare.com/media/37746242/link.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "WSB", name: "WallStreetBets DApp", base: "USD", rate: 0, flow24Hours: 0, logo: "WSB", imageUrl: "www.cryptocompare.com/media/39383061/wsb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BONK", name: "Bonk", base: "USD", rate: 0, flow24Hours: 0, logo: "BONK", imageUrl: "www.cryptocompare.com/media/43977068/bonk.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LTC", name: "Litecoin", base: "USD", rate: 0, flow24Hours: 0, logo: "LTC", imageUrl: "www.cryptocompare.com/media/37746243/ltc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ETC", name: "Ethereum Classic", base: "USD", rate: 0, flow24Hours: 0, logo: "ETC", imageUrl: "www.cryptocompare.com/media/37746862/etc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LDO", name: "Lido DAO", base: "USD", rate: 0, flow24Hours: 0, logo: "LDO", imageUrl: "www.cryptocompare.com/media/40485192/ldo.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TIA", name: "Celestia", base: "USD", rate: 0, flow24Hours: 0, logo: "TIA", imageUrl: "www.cryptocompare.com/media/44154182/tia.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "FIL", name: "FileCoin", base: "USD", rate: 0, flow24Hours: 0, logo: "FIL", imageUrl: "www.cryptocompare.com/media/37747014/fil.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "MANTLE", name: "Mantle", base: "USD", rate: 0, flow24Hours: 0, logo: "MANTLE", imageUrl: "www.cryptocompare.com/media/44154179/mantle.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SEI", name: "Sei", base: "USD", rate: 0, flow24Hours: 0, logo: "SEI", imageUrl: "www.cryptocompare.com/media/44082123/sei.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "INJ", name: "Injective", base: "USD", rate: 0, flow24Hours: 0, logo: "INJ", imageUrl: "www.cryptocompare.com/media/43687858/inj.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SHIB", name: "Shiba Inu", base: "USD", rate: 0, flow24Hours: 0, logo: "SHIB", imageUrl: "www.cryptocompare.com/media/37747199/shib.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BCH", name: "Bitcoin Cash", base: "USD", rate: 0, flow24Hours: 0, logo: "BCH", imageUrl: "www.cryptocompare.com/media/37746245/bch.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ICP", name: "Internet Computer", base: "USD", rate: 0, flow24Hours: 0, logo: "ICP", imageUrl: "www.cryptocompare.com/media/37747502/icp.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "STX", name: "Stacks", base: "USD", rate: 0, flow24Hours: 0, logo: "STX", imageUrl: "www.cryptocompare.com/media/37746986/stx.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "DOT", name: "Polkadot", base: "USD", rate: 0, flow24Hours: 0, logo: "DOT", imageUrl: "www.cryptocompare.com/media/39334571/dot.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TRX", name: "TRON", base: "USD", rate: 0, flow24Hours: 0, logo: "TRX", imageUrl: "www.cryptocompare.com/media/37746879/trx.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "NEAR", name: "Near", base: "USD", rate: 0, flow24Hours: 0, logo: "NEAR", imageUrl: "www.cryptocompare.com/media/37458963/near.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "PEOPLE", name: "ConstitutionDAO", base: "USD", rate: 0, flow24Hours: 0, logo: "PEOPLE", imageUrl: "www.cryptocompare.com/media/39198201/people.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ENS", name: "Ethereum Name Service", base: "USD", rate: 0, flow24Hours: 0, logo: "ENS", imageUrl: "www.cryptocompare.com/media/38554045/ens.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "APT", name: "Aptos", base: "USD", rate: 0, flow24Hours: 0, logo: "APT", imageUrl: "www.cryptocompare.com/media/43881360/apt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SUI", name: "Sui", base: "USD", rate: 0, flow24Hours: 0, logo: "SUI", imageUrl: "www.cryptocompare.com/media/44082045/sui.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TUSD", name: "True USD", base: "USD", rate: 0, flow24Hours: 0, logo: "TUSD", imageUrl: "www.cryptocompare.com/media/38554125/tusd.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "GMT", name: "STEPN", base: "USD", rate: 0, flow24Hours: 0, logo: "GMT", imageUrl: "www.cryptocompare.com/media/39838490/gmt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BSV", name: "Bitcoin SV", base: "USD", rate: 0, flow24Hours: 0, logo: "BSV", imageUrl: "www.cryptocompare.com/media/44082082/bsv.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "WBTC", name: "Wrapped Bitcoin", base: "USD", rate: 0, flow24Hours: 0, logo: "WBTC", imageUrl: "www.cryptocompare.com/media/35309588/wbtc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TONCOIN", name: "The Open Network", base: "USD", rate: 0, flow24Hours: 0, logo: "TONCOIN", imageUrl: "www.cryptocompare.com/media/43957906/toncoin.png", colorIndex: -1)
        ]
    }
    
}
