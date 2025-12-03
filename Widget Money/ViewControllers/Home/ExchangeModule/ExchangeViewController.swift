//
//  ExchangeView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit
import Foundation
import Combine

class ExchangeViewController: UIViewController {
    
    let viewModel = ExchangeViewModel()
    var cancellables = Set<AnyCancellable>()
    
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
        viewModel.$fromText.sink { text in
            self.fromView.textField.text = text
            if text != "1.0" {
                self.fromView.textField.textColor = self.viewModel.colorSet.mainText
                self.toView.textField.textColor = self.viewModel.colorSet.mainText
            }
        }.store(in: &cancellables)
        
        //Setting to ToView
        viewModel.$toText.sink { text in
            self.toView.textField.text = text
        }.store(in: &cancellables)
        
        //Setting currency names
        viewModel.$fromCurrency.sink { text in
            self.fromView.currencyButton.setTitle(" \(text)", for: .normal)
        }.store(in: &cancellables)
        
        viewModel.$toCurrency.sink { text in
            self.toView.currencyButton.setTitle(" \(text)", for: .normal)
        }.store(in: &cancellables)
        
    
        
        //Setup Choose currency button
        
        // From button
        fromView.currencyButton.addTarget(
            self,
            action: #selector(fromCurrencyTapped),
            for: .touchUpInside
        )

        // To button
        toView.currencyButton.addTarget(
            self,
            action: #selector(toCurrencyTapped),
            for: .touchUpInside
        )
        

        //Getting from FromView
        fromView.textField.addTarget(
            self,
            action: #selector(fromTextChanged),
            for: .editingChanged
        )
        
        //Getting from ToView
        toView.textField.addTarget(
            self,
            action: #selector(toTextChanged),
            for: .editingChanged
        )
        
        changeButton.addTarget(
            self,
            action: #selector(switchFields),
            for: .touchUpInside)
   
    }
    
    @objc private func fromTextChanged(_ textField: UITextField) {
        handleTextChange(textField, normalExchange: true)
    }

    @objc private func toTextChanged(_ textField: UITextField) {
        handleTextChange(textField, normalExchange: false)
    }
    
    private func handleTextChange(_ textField: UITextField, normalExchange: Bool) {
        let str = textField.text ?? ""

        if normalExchange {
            viewModel.fromText = str
            viewModel.makeExchangeNormal()
        } else {
            viewModel.toText = str
            viewModel.makeExchangeReverse()
        }

        if str == "1" {
            fromView.textField.textColor = viewModel.colorSet.secondText.withAlphaComponent(0.7)
            toView.textField.textColor = viewModel.colorSet.secondText.withAlphaComponent(0.7)
        } else {
            fromView.textField.textColor = viewModel.colorSet.mainText
            toView.textField.textColor = viewModel.colorSet.mainText
        }
    }
    
    @objc private func switchFields() {
        viewModel.switchFields()
    }
    
    @objc private func fromCurrencyTapped() {
        typeOfRow = "From"
        let vc = ChooseCurrencyViewController()
        vc.delegate = self
        present(vc, animated: true)
    }

    @objc private func toCurrencyTapped() {
        typeOfRow = "To"
        let vc = ChooseCurrencyViewController()
        vc.modalPresentationStyle = .automatic
        vc.delegate = self
        present(vc, animated: true)
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
        viewModel.$rxAppThemeUpdated.sink { flag in
            if flag {
                self.colorsUpdate()
            }
        }.store(in: &cancellables)
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


