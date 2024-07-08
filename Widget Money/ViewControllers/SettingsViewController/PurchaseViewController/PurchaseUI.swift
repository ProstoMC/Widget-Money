//
//  PurchseUI.swift
//  Widget Money
//
//  Created by admin on 30.06.24.
//

import SwiftUI
import StoreKit
import RxSwift

class purchaseViewModel: ObservableObject {
    @Published var description: String = "Error"
    @Published var isHidden: Bool = false
    
    let bag = DisposeBag()
    func subscribing(product: Product) {
        CoreWorker.shared.purchaseWorker.rxProductPurchased.subscribe(onNext: { _ in
            self.updateView(product: product)
            
        }).disposed(by: bag)
    }
    
    func updateView(product: Product) {
        
        if CoreWorker.shared.purchaseWorker.isProductPurchased(product.id) {
            description = "✅ Already purchased "
            isHidden = true
        }
        else {
            description = product.description
            isHidden = false
        }
    }
}


struct PurchaseUI: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = purchaseViewModel()
    
    var product: Product
    var colorSet: AppColors
    var baseHeight = UIScreen.main.bounds.height*0.058
    var bag = DisposeBag()
    
    init(product: Product, colorSet: AppColors) {
        self.product = product
        self.colorSet = colorSet
        viewModel.updateView(product: product)
        viewModel.subscribing(product: product)
        //subscribing()
    }
    
//    private mutating func subscribing() {

//    }
    

    
    var body: some View {
        ZStack {
            Color.init(uiColor: colorSet.background)
            VStack {
                LineView(
                    width: UIScreen.main.bounds.width*0.2,
                    height: baseHeight/8,
                    color: Color.init(uiColor: colorSet.closingLine)
                ).padding(baseHeight/3)
                
                Spacer()
                
                Image(product.id + ".BIG")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width*0.4)
                    .padding(30)
                
                Text(product.displayName)
                    .font(.title)
                    .foregroundStyle(Color.init(uiColor: colorSet.mainText))
                
                Text(viewModel.description)
                    .font(.title2)
                    .foregroundStyle(/*viewModel.isHidden ? Color.init(uiColor: colorSet.green) : */Color.init(uiColor: colorSet.mainText))
                    .padding(.top, 10)
                
                LineView(
                    width: UIScreen.main.bounds.width * 0.9,
                    height: 1,
                    color: Color.init(uiColor: colorSet.secondText)
                ).padding(10)
                
                //Show and hide buy button
                if !viewModel.isHidden {
                    Button(action: {
                        Task {
                             do {
                                 try await CoreWorker.shared.purchaseWorker.makePurchase(product)
                             } catch {
                                 print(error)
                             }
                         }
                    }) {
                        Text("Buy now for " + product.displayPrice)
                            .font(.title2)
                    }
                    .buttonStyle(CapsuleButtonStyle(
                        backgroundColor: Color.init(uiColor: colorSet.detailsBackground),
                        foregroundColor: Color.init(uiColor: colorSet.detailsTextColor)
                    ))
                    .padding()
                }
                Button(action: {
                    CoreWorker.shared.purchaseWorker.restorePurchases()
                }) {
                    Text("Restore purchase")
                        .foregroundColor(Color.init(uiColor: colorSet.closingLine))
                        .font(.title2)
                }
                .buttonStyle(.borderless)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Back")
                        .foregroundColor(Color.init(uiColor: colorSet.secondText))
                        .font(.title2)
                }
                .padding(10)
                Spacer()
            }
        }.ignoresSafeArea()
    }
    
    private func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            print(error.localizedDescription)
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
}

//#Preview {
//    PurchaseUI(
//        product: Product(,
//        colorSet: CoreWorker.shared.colorsWorker.returnColors())
//}

struct CapsuleButtonStyle: ButtonStyle {
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.width*0.12)
            .foregroundColor(
                configuration.isPressed ? foregroundColor.opacity(0.5) : foregroundColor)
            .background(configuration.isPressed ? backgroundColor.opacity(0.5) : backgroundColor)
            .cornerRadius(UIScreen.main.bounds.width*0.06)
            
    }
}

struct LineView: View {
    
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var body: some View {
        color
            .frame(width: width, height: height)
            .cornerRadius(height/2)
    }
}
