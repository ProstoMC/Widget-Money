//
//  PurchaseViewController.swift
//  Widget Money
//
//  Created by admin on 13.05.24.
//

import UIKit
import RxSwift

class PurchaseViewController: UIViewController {

    var price = 0
    var adsIsHidden = false
    
    var colorSet: AppColors!
    
    let disposeBag = DisposeBag()
    
    var closingLine = UIView()
    
    var headLabel = UILabel()
    
    var infoTextView = UITextView()
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
    
    // MARK:  - RX Subscribing
    private func rxSubscribing() {
//        CoreWorker.shared.adsWorker.price.subscribe(onNext: { price in
//            let title = "Remove ads for".localized() + " " + price
//            self.buyButton.setTitle(title, for: .normal)
//        }).disposed(by: disposeBag)
        
        CoreWorker.shared.adsWorker.adsIsHidden.subscribe(onNext: { isHidden in
            self.buyButton.isHidden = isHidden
            self.restoreButton.isHidden = isHidden
            
            self.okImage.isHidden = !isHidden
            
            if isHidden {
                self.infoTextView.text = "Advertisement banners have been removed".localized()
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}



// MARK:  - SETUP UI
extension PurchaseViewController {
    private func setupUI() {
        
        baseHeightOfElements = getBaseHeight()
        setupClosingLine()
        setupHeadLabel()
        setupTextView()
        setupSaveButton()
        setupRestoreButton()
        setupBackButton()
        setupOkImage()
        updateColors()
    }
    
    private func updateColors(){
        
        view.backgroundColor = colorSet.background
        
        closingLine.backgroundColor = colorSet.closingLine
        
        headLabel.textColor = colorSet.settingsText
        
        buyButton.backgroundColor = colorSet.detailsBackground
        buyButton.setTitleColor(colorSet.detailsTextColor, for: .normal)
        restoreButton.setTitleColor(colorSet.closingLine, for: .normal)
        backButton.setTitleColor(colorSet.secondText, for: .normal)
        
        infoTextView.textColor = colorSet.mainText.withAlphaComponent(0.8)
        infoTextView.backgroundColor = colorSet.background
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
    
    private func setupHeadLabel() {
        view.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            headLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            headLabel.topAnchor.constraint(equalTo: closingLine.bottomAnchor, constant: baseHeightOfElements/3),
            headLabel.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        headLabel.text = "Remove ads".localized()
        headLabel.textAlignment = .center
        headLabel.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        headLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setupTextView() {
        view.addSubview(infoTextView)
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoTextView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.7),
            infoTextView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: baseHeightOfElements),
            infoTextView.heightAnchor.constraint(equalToConstant: baseHeightOfElements*1.8)
        ])
        
        infoTextView.text = "Hide all advertisement banners with in-app purchase".localized()
        infoTextView.font = UIFont.systemFont(ofSize: baseHeightOfElements*0.5)
        infoTextView.textAlignment = .center
        
    }
    
    
    private func setupSaveButton() {
        view.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.8),
            buyButton.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: baseHeightOfElements),
            buyButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements*1.2)
        ])
        buyButton.layer.cornerRadius = baseHeightOfElements*0.4
        
        
        //buyButton.setTitle("Remove ads for 1.49$".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        

        
        buyButton.addAction(UIAction { _ in
            
            self.dismiss(animated: true)
        }, for: .touchUpInside)
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
            okImage.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: baseHeightOfElements*0.9),
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

