//
//  PurchaseViewController.swift
//  Widget Money
//
//  Created by admin on 13.05.24.
//

import UIKit
import RxSwift
import StoreKit

class PurchaseViewController: UIViewController {

    var product: SKProduct? = nil
    var adsIsHidden = false
    
    var colorSet: AppColors!
    
    let disposeBag = DisposeBag()
    
    var closingLine = UIView()
    
    var titleLabel = UILabel()
    
    var descriptionTextView = UITextView()
    var buyButton = UIButton()
    var restoreButton = UIButton()
    var backButton = UIButton()
    
    var okImage = UIImageView()
    
    var baseHeightOfElements: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupUI()
        rxSubscribing()
    }
    
//    func configure(productID: String) {
//        
//        product = PurchaseWorker.shared.returnProduct(productID: productID)
//        
//        if product != nil {
//            let price = formatPrice(product: product!)
//            let buyButtonTitle = product!.localizedTitle.localized() + " " + "for".localized() + " " + price
//            
//            titleLabel.text = product!.localizedTitle.localized()
//            print(product!.localizedTitle)
//            descriptionTextView.text = product!.localizedDescription.localized()
//            buyButton.setTitle(buyButtonTitle, for: .normal)
//            
//            buyButton.addAction(UIAction { _ in
//                PurchaseWorker.shared.makePurchase(product: self.product!)
//            }, for: .touchUpInside)
//            
//        }
//    }
    
    // MARK:  - RX Subscribing
    private func rxSubscribing() {
        
        CoreWorker.shared.adsWorker.adsIsHidden.subscribe(onNext: { isHidden in
            self.buyButton.isHidden = isHidden
            self.restoreButton.isHidden = isHidden
            
            self.okImage.isHidden = !isHidden
            
            if isHidden {
                self.descriptionTextView.text = "Advertisement banners have been removed".localized()
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func formatPrice(product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? "No data"
    }
    
}




// MARK:  - SETUP UI
extension PurchaseViewController {
    private func setupUI() {
        
        baseHeightOfElements = getBaseHeight()
        setupClosingLine()
        setupTitleLabel()
        setupDescriptionView()
        setupBuyButton()
        setupRestoreButton()
        setupBackButton()
        setupOkImage()
        updateColors()
    }
    
    private func updateColors(){
        
        view.backgroundColor = colorSet.background
        
        closingLine.backgroundColor = colorSet.closingLine
        
        titleLabel.textColor = colorSet.settingsText
        
        buyButton.backgroundColor = colorSet.detailsBackground
        buyButton.setTitleColor(colorSet.detailsTextColor, for: .normal)
        restoreButton.setTitleColor(colorSet.closingLine, for: .normal)
        backButton.setTitleColor(colorSet.secondText, for: .normal)
        
        descriptionTextView.textColor = colorSet.mainText.withAlphaComponent(0.8)
        descriptionTextView.backgroundColor = colorSet.background
        okImage.tintColor = colorSet.green
        
    }
    
    private func setupClosingLine() {
        view.addSubview(closingLine)
        closingLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closingLine.topAnchor.constraint(equalTo: view.topAnchor, constant: baseHeightOfElements/3),
            closingLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closingLine.heightAnchor.constraint(equalToConstant: baseHeightOfElements/8),
            closingLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
        ])
        
        closingLine.layer.cornerRadius = baseHeightOfElements/16
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            titleLabel.topAnchor.constraint(equalTo: closingLine.bottomAnchor, constant: baseHeightOfElements/3),
            titleLabel.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        //titleLabel.text = "Remove ads".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(baseHeightOfElements*0.5)
        titleLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setupDescriptionView() {
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.7),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: baseHeightOfElements),
            descriptionTextView.heightAnchor.constraint(equalToConstant: baseHeightOfElements*1.8)
        ])
        
       // descriptionTextView.text = "Hide all advertisement banners".localized()
        descriptionTextView.font = UIFont.systemFont(ofSize: baseHeightOfElements*0.5)
        descriptionTextView.textAlignment = .center
        
    }
    
    
    private func setupBuyButton() {
        view.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.8),
            buyButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: baseHeightOfElements),
            buyButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements*1.2)
        ])
        buyButton.layer.cornerRadius = baseHeightOfElements*0.4
        
        
        //buyButton.setTitle("Remove ads for 1.49$".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)


    }
    
    private func setupRestoreButton() {
        view.addSubview(restoreButton)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.7),
            restoreButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: baseHeightOfElements*0.9),
            restoreButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5)
        ])
        //backButton.layer.cornerRadius = baseHeightOfElements*0.375
        
        restoreButton.setTitle("Restore purchase".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        
        restoreButton.addAction(UIAction { _ in
            
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.35),
            backButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: baseHeightOfElements*0.9),
            backButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5)
        ])
        //backButton.layer.cornerRadius = baseHeightOfElements*0.375
        
        backButton.setTitle("Back".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        
        backButton.addAction(UIAction { _ in
            
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }
    
    private func setupOkImage() {
        view.addSubview(okImage)
        okImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            okImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: baseHeightOfElements*0.1),
            okImage.widthAnchor.constraint(equalToConstant: baseHeightOfElements*2),
            okImage.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: baseHeightOfElements*0.9),
            okImage.heightAnchor.constraint(equalToConstant: baseHeightOfElements*2)
        ])
        //backButton.layer.cornerRadius = baseHeightOfElements*0.375
        
        okImage.image = UIImage(systemName: "checkmark")
        okImage.contentMode = .scaleAspectFit
        
        
    }
    
    private func getBaseHeight() -> Double {
        var height = UIScreen.main.bounds.height*0.058
        
        
        if height > 40 {
            height = 40
        } else {
            height = Double(Int(height)) // Deleting fraction
        }
        print (height)
        return height
    }
    
    
}

