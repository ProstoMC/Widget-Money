//
//  ExchangeView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class ExchangeViewController: UIViewController {
    
    let viewModel: ExchangeViewModelProtocol = ExchangeViewModel()
    let disposeBag = DisposeBag()
    
    let exchangeLabel = UILabel()
    let changeButton = UIButton()
    
    let fromView = EnterCurrencyView()
    let toView = EnterCurrencyView()
    
    var typeOfRow = "" //To or From
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .yellow
        setupRx()
        setupUI()
    }

}
// MARK: -  SETUP RX
extension ExchangeViewController {
    private func setupRx() {
  
        //Setting to FromView
        viewModel.fromText.subscribe(onNext: { text in
            self.fromView.textField.text = text
            if text != "1.0" {
                self.fromView.textField.textColor = self.viewModel.colorSet.mainText
                self.toView.textField.textColor = self.viewModel.colorSet.mainText
            }
        }).disposed(by: disposeBag)
        
        //Setting to ToView
        viewModel.toText.subscribe(onNext: { text in
            self.toView.textField.text = text
        }).disposed(by: disposeBag)
        
        //Setting currency names
        viewModel.fromCurrency.subscribe(onNext: { text in
            self.fromView.currencyButton.setTitle(" \(text)", for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.toCurrency.subscribe(onNext: { text in
            self.toView.currencyButton.setTitle(" \(text)", for: .normal)
        }).disposed(by: disposeBag)
        
        
        //Getting from FromView
        fromView.textField.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                self.viewModel.fromText.on(.next(str))
                self.viewModel.makeExchangeNormal()
                
                if str == "1" {
                    self.fromView.textField.textColor = self.viewModel.colorSet.secondText.withAlphaComponent(0.7)
                    self.toView.textField.textColor = self.viewModel.colorSet.secondText.withAlphaComponent(0.7)
                } else {
                    self.fromView.textField.textColor = self.viewModel.colorSet.mainText
                    self.toView.textField.textColor = self.viewModel.colorSet.mainText
                }
            }).disposed(by: disposeBag)
        
        //Getting from ToView
        toView.textField.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                self.viewModel.toText.on(.next(str))
                self.viewModel.makeExchangeReverse()

            }).disposed(by: disposeBag)
        
        //Setup button
        changeButton.rx.tap.asDriver().drive(onNext: {
            self.viewModel.switchFields()
        }).disposed(by: disposeBag)
        
        //Setup Choose currency button
        
        fromView.currencyButton.rx.tap.asDriver().drive(onNext: {
            self.typeOfRow = "From"
            let vc = ChooseCurrencyViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        
        toView.currencyButton.rx.tap.asDriver().drive(onNext: {
            self.typeOfRow = "To"
            let vc = ChooseCurrencyViewController()
            vc.modalPresentationStyle = .automatic
            vc.delegate = self
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
   
    }
}

extension ExchangeViewController: ReturnDataFromChooseViewControllerProtocol {
    func passCurrencyShortName(name: String?) {
        if name != nil {
            viewModel.setCurrency(shortName: name!, type: typeOfRow)
        }
    }   
}

// MARK:  - SETUP UI
extension ExchangeViewController: UITextFieldDelegate {
    private func setupUI() {
        
        setupChangeButton()
        setupHeader()
        setupFromView()
        setupToView()
        rxColors()
    }
    
    private func rxColors() {
        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.colorsUpdate()
            }
        }).disposed(by: disposeBag)
    }
    
    private func colorsUpdate() {
        changeButton.imageView?.tintColor = viewModel.colorSet.mainColor
        exchangeLabel.textColor = viewModel.colorSet.mainText
        changeButton.backgroundColor = viewModel.colorSet.accentColor
        fromView.updateColors(colorSet: viewModel.colorSet)
        toView.updateColors(colorSet: viewModel.colorSet)
    }
    
    private func setupChangeButton() {
        view.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            changeButton.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        view.layoutIfNeeded()
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = UIScreen.main.bounds.height/100
        
        changeButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        
        changeButton.imageView?.contentMode = .scaleAspectFit

    }
    
    
    
    private func setupHeader() {
        view.addSubview(exchangeLabel)
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            exchangeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.75),
            exchangeLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            exchangeLabel.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor),
        ])
        
        exchangeLabel.text = "Exchange".localized()
        exchangeLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        exchangeLabel.adjustsFontSizeToFitWidth = true
        exchangeLabel.textAlignment = .left
        
    }
    
    private func setupFromView() {
        view.addSubview(fromView)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        fromView.header.text = "From".localized()
        fromView.textField.text = "1"
        
        NSLayoutConstraint.activate([
            fromView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            fromView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fromView.rightAnchor.constraint(equalTo: view.rightAnchor),
            fromView.topAnchor.constraint(equalTo: changeButton.bottomAnchor), // 0.05 of view
        ])
    }
    private func setupToView() {
        view.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        toView.header.text = "To".localized()
        
        NSLayoutConstraint.activate([
            toView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            toView.leftAnchor.constraint(equalTo: view.leftAnchor),
            toView.rightAnchor.constraint(equalTo: view.rightAnchor),
            toView.topAnchor.constraint(equalTo: fromView.bottomAnchor, constant: UIScreen.main.bounds.height*0.0125), // 0.05 of view
        ])
        
        
    }
}

// MARK:  - SETUP KEYBOARD
extension ExchangeViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}


