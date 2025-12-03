//
//  PurchaseWorker.swift
//  Widget Money
//
//  Created by admin on 27.05.24.
//

import Foundation
import StoreKit
import Combine

protocol PurchaseWorkerProtocol {
    var rxProductsFetchedFlag: Bool { get }
    var rxProductPurchased: Bool { get }
    var rxAdsIsHidden: Bool { get }
    
    func makePurchase(_ product: Product) async throws
    func returnProducts() -> [Product]
    func returnProduct(productID: String) -> Product?
    func updatePurchasedProducts() async
    func restorePurchases()
    
    func isProductPurchased(_ id: String) -> Bool
    
}

class PurchaseWorker {
    
    let productIDs: Set<String> = [
        "com.sloniklm.WidgetMoney.HideAds",
       // "com.sloniklm.WidgetMoney.Test"
    ]
    
    var purchasedProductIDs: Set<String> = []
    
    @Published private(set) var rxProductsFetchedFlag: Bool = false
    @Published private(set) var rxProductPurchased: Bool = false
    @Published private(set) var rxAdsIsHidden: Bool = false
    private var updates: Task<Void, Never>? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    var products: [Product] = []

    init() {
        subscribing()
        rxProductsFetchedFlag = true
        //Fetching products
        Task {
            do {
                try await fetchProducts()
                rxProductsFetchedFlag = true
            } catch { return }
        }
        
        //Checking purchased products
        Task {
            await updatePurchasedProducts()
            rxProductsFetchedFlag = true
        }
        updates = observeTransactionUpdates()
    }
    deinit {
           updates?.cancel()
       }
    
    private func fetchProducts() async throws {
        products = try await Product.products(for: productIDs)
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    //For transactions from anywhere
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
    
    func subscribing() {
        $rxProductPurchased.sink { _ in
            if self.isProductPurchased("com.sloniklm.WidgetMoney.RemoveAd") {
                DispatchQueue.main.async {
                    self.rxAdsIsHidden = true
                }
            }
        }.store(in: &cancellables)
        
        $rxProductsFetchedFlag.sink { _ in
            if self.isProductPurchased("com.sloniklm.WidgetMoney.RemoveAd") {
                DispatchQueue.main.async {
                    self.rxAdsIsHidden = true
                }
            }
        }.store(in: &cancellables)
    }
    
}

extension PurchaseWorker: PurchaseWorkerProtocol {
    func isProductPurchased(_ id: String) -> Bool {
//        print("===PURCHASED PRODUCT IDs===")
//        print("ID Checked: \(id)")
        let result = purchasedProductIDs.contains(id)
       // print (result)
        return result
    }
    
   //Restore purchase
    func restorePurchases() {
        Task {
            do {
                try await AppStore.sync()
                await MainActor.run {
                    self.rxProductPurchased = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    func makePurchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            await self.updatePurchasedProducts()
            await MainActor.run {
                self.rxProductPurchased = true
            }
           
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            print(error.localizedDescription)
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    func returnProducts() -> [Product] {
        return products
    }
    
    func returnProduct(productID: String) -> Product? {
        var product: Product? = nil
        products.forEach({
            if $0.id == productID {
                product = $0
            }
        })
        return product
    }
}
