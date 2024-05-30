//
//  PurchaseWorker.swift
//  Widget Money
//
//  Created by admin on 27.05.24.
//

import Foundation
import StoreKit
import RxSwift

protocol PurchaseWorkerProtocol {
    var rxProductsFetchedFlag: BehaviorSubject<Bool> { get }
    
    
    
    func returnProducts() -> [SKProduct]
    
}

class PurchaseWorker: NSObject, PurchaseWorkerProtocol {
    
    var rxProductsFetchedFlag = BehaviorSubject(value: false)
    
    let productsID: Set = ["com.sloniklm.WidgetMoney.RemoveAd", 
                           //"com.sloniklm.WidgetMoney.Test"
                            ]
    
    var products: [SKProduct] = []
    
    override init() {
        super.init()
        
        setupPurchases(callback: { success in
            if success {
                print("-----WE CAN MAKE PAYMENTS")
                self.fetchProducts()
            }
            else {
                print("-----ERROR PAYMENTS")
            }
        })
    }
    
    func returnProducts() -> [SKProduct] {
        return products
    }
    
}

extension PurchaseWorker {

    
    public func setupPurchases(callback: @escaping (Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            //SKPaymentQueue.default().addObserver(self)
            
            callback(true)
        }
        else {
            callback(false)
        }
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productsID)
        request.delegate = self
        request.start()
    }
    
    func getPriceOf(product: SKProduct) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? "No data"
    }
    
    
    
}

extension PurchaseWorker: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
}

extension PurchaseWorker: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        #if DEBUG
        print("------WE HAVE \(products.count) PRODUCTS")
        response.products.forEach({ print("\($0.localizedDescription) - \(self.getPriceOf(product: $0)) - \($0.priceLocale)")})
        #endif
        
        products = response.products
        rxProductsFetchedFlag.onNext(true)
    }
}
