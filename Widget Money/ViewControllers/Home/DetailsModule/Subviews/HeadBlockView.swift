//
//  HeadBlock.swift
//  Widget Money
//
//  Created by  slm on 24.02.2024.
//

import UIKit

class HeadBlockView: UIView {
    
    let valueNameBlock = NameAndCountryBlock()
    let baseNameBlock = NameAndCountryBlock()

    
    let arrowScaledView = ArrowScaledView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(valueCoin: CoinUniversal, baseCoin: CoinUniversal) {
         
    }
    
    
    

}

extension HeadBlockView {
    private func setupUI() {
        setupValueBlock()
        setupScaledArrow()
        setupBaseBlock()
    }
    
    private func setupValueBlock() {
        self.addSubview(valueNameBlock)
        valueNameBlock.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueNameBlock.leftAnchor.constraint(equalTo: self.leftAnchor),
            valueNameBlock.topAnchor.constraint(equalTo: self.topAnchor),
            valueNameBlock.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            valueNameBlock.heightAnchor.constraint(equalTo: self.heightAnchor),
            ])
    }
    
    private func setupScaledArrow() {
        self.addSubview(arrowScaledView)
        arrowScaledView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            arrowScaledView.leftAnchor.constraint(equalTo: valueNameBlock.rightAnchor),
            arrowScaledView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            arrowScaledView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            arrowScaledView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            ])
    }
    
    private func setupBaseBlock() {
        self.addSubview(baseNameBlock)
        baseNameBlock.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseNameBlock.leftAnchor.constraint(equalTo: arrowScaledView.rightAnchor, constant: UIScreen.main.bounds.width*0.08),
            baseNameBlock.topAnchor.constraint(equalTo: self.topAnchor),
            baseNameBlock.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            baseNameBlock.heightAnchor.constraint(equalTo: self.heightAnchor),
            ])
    }
    
}


