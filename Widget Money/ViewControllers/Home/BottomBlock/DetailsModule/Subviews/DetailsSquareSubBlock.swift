//
//  DetailsSquareSubBlock.swift
//  Widget Money
//
//  Created by  slm on 29.02.2024.
//

import UIKit

class DetailsSquareSubBlock: UIView {
    
    let lineView = UIView()
    let upLabel = UILabel()
    let downLabel = UILabel()
    
    let subBlockForLayout = UIView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(pair: CurrencyPairCellModel, multiplier: Int) {
        let upText = NSMutableAttributedString(
            string: String(multiplier),
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        upText.append(NSAttributedString(
            string: " " + pair.valueCurrencyLogo,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        upLabel.attributedText = upText
        
        let value = pair.value * Double(multiplier)
        
        let downText = NSMutableAttributedString(
            string: String(format: "%.2f", value),
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        downText.append(NSAttributedString(
            string: " " + pair.baseLogo,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        downLabel.attributedText = downText
        
    }
    
    func updateColors(colorSet: AppColors) {
        lineView.backgroundColor = .white.withAlphaComponent(0.2)
        backgroundColor = colorSet.detailsSquareSubviewBackground
        downLabel.textColor = .white
        upLabel.textColor = .white
    }

}

extension DetailsSquareSubBlock {
    
    private func setupUI() {
        
        setupSubBlock()
        setupLine()
        setupUpLabel()
        setupDownLabel()
        
    }
    
    private func setupSubBlock() {
        self.addSubview(subBlockForLayout)
        subBlockForLayout.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subBlockForLayout.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subBlockForLayout.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            subBlockForLayout.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            subBlockForLayout.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
        ])
    }
    
    private func setupUpLabel() {
        self.addSubview(upLabel)
        upLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width * 0.03),
            upLabel.centerYAnchor.constraint(equalTo: subBlockForLayout.topAnchor),
            upLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            upLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
        ])
        
        
        
        upLabel.font = .systemFont(ofSize: 100)
        upLabel.adjustsFontSizeToFitWidth = true
        
        

        
    }
    
    private func setupDownLabel() {
        self.addSubview(downLabel)
        downLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width * 0.03),
            downLabel.centerYAnchor.constraint(equalTo: subBlockForLayout.bottomAnchor),
            downLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            downLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
        ])
        
        
        downLabel.font = .systemFont(ofSize: 100)
        downLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setupLine() {
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            lineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.01),
        ])
        
    }
}


