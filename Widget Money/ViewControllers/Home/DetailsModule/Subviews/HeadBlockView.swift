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

    var valueBlockWidth = NSLayoutConstraint()
    var arrowWidth = NSLayoutConstraint()
    var baseBlockWidth = NSLayoutConstraint()
    
    var maxLenghtOfText = UIScreen.main.bounds.width*0.5
 
    
    let arrowScaledView = ArrowScaledView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(coinPair: CurrencyPairCellModel) {
        valueNameBlock.configure(name: coinPair.valueCurrencyName)
        baseNameBlock.configure(name: coinPair.baseCurrencyName)
        
        arrowWidth.constant = UIScreen.main.bounds.width*0.1
        var lenghtOfText = valueNameBlock.lenghtOfText + baseNameBlock.lenghtOfText
        
        valueBlockWidth.constant = valueNameBlock.lenghtOfText
        baseBlockWidth.constant = baseNameBlock.lenghtOfText
        
        //Deminish row
        
        if lenghtOfText > maxLenghtOfText {
            arrowWidth.constant = UIScreen.main.bounds.width*0.05
        }
        
        //Deminish blocks
        if lenghtOfText > maxLenghtOfText*1.2 {
            if valueBlockWidth.constant > maxLenghtOfText*0.5 {
                valueBlockWidth.constant = maxLenghtOfText - baseBlockWidth.constant
            }
            if baseBlockWidth.constant > maxLenghtOfText*0.5 {
                baseBlockWidth.constant = maxLenghtOfText - valueBlockWidth.constant
            }
        }
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
            //valueNameBlock.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            valueNameBlock.heightAnchor.constraint(equalTo: self.heightAnchor),
            ])
        
        
        valueBlockWidth = NSLayoutConstraint(
            item: valueNameBlock,
            attribute: .width,
            relatedBy: .equal,
            toItem: .none,
            attribute: .notAnAttribute,
            multiplier: .nan,
            constant: 10)
        valueBlockWidth.isActive = true
    }
    
    private func setupScaledArrow() {
        self.addSubview(arrowScaledView)
        arrowScaledView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            arrowScaledView.leftAnchor.constraint(equalTo: valueNameBlock.rightAnchor, constant: UIScreen.main.bounds.width*0.02),
            arrowScaledView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            //arrowScaledView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            arrowScaledView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
        
            ])
        
        arrowWidth = NSLayoutConstraint(
            item: arrowScaledView,
            attribute: .width,
            relatedBy: .equal,
            toItem: .none,
            attribute: .notAnAttribute,
            multiplier: .nan,
            constant: UIScreen.main.bounds.width*0.1)
        arrowWidth.isActive = true
    }
    
    private func setupBaseBlock() {
        self.addSubview(baseNameBlock)
        baseNameBlock.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseNameBlock.leftAnchor.constraint(equalTo: arrowScaledView.rightAnchor, constant: UIScreen.main.bounds.width*0.02),
            baseNameBlock.topAnchor.constraint(equalTo: self.topAnchor),
            //baseNameBlock.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            baseNameBlock.heightAnchor.constraint(equalTo: self.heightAnchor),
            ])
        
        baseBlockWidth = NSLayoutConstraint(
            item: baseNameBlock,
            attribute: .width,
            relatedBy: .equal,
            toItem: .none,
            attribute: .notAnAttribute,
            multiplier: .nan,
            constant: 10)
        baseBlockWidth.isActive = true
    }
    
}


