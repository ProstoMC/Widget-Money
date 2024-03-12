//
//  DetailsLongBlock.swift
//  Widget Money
//
//  Created by  slm on 29.02.2024.
//

import UIKit

class DetailsLongSubBlock: UIView {
    
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let arrowScaledView = ArrowScaledView()
    
    let flowLabel = UILabel()
    let flowPercentLabel = UILabel()
    
    let upImageView = UIImageView()
    let downImageView = UIImageView()
    
    var lenghtOfText: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(pair: CurrencyPairCellModel, colorSet: AppColors) {
        
        let fromText = NSMutableAttributedString(
            string: "1",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        fromText.append(NSAttributedString(
            string: pair.valueCurrencyLogo,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        fromLabel.attributedText = fromText
        
        let toText = NSMutableAttributedString(
            string: String(format: "%.2f", pair.value),
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        toText.append(NSAttributedString(
            string: pair.baseLogo,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        toLabel.attributedText = toText
        
        flowLabel.text = String(format: "%.2f", pair.flow) + " " + pair.baseLogo
        let flowPercent = pair.flow/(pair.value-pair.flow)
        flowPercentLabel.text = String(format: "%.3f", flowPercent) + " %"
        
        if pair.flow >= 0 {
            upImageView.isHidden = false
            downImageView.isHidden = true
            
            flowLabel.textColor = colorSet.green
            flowPercentLabel.textColor = colorSet.green
        } else {
            upImageView.isHidden = true
            downImageView.isHidden = false
            
            flowLabel.textColor = colorSet.red
            flowPercentLabel.textColor = colorSet.red
        }
        
    }
    
    func updateColors(colorSet: AppColors){
        backgroundColor = colorSet.detailsLongSubviewBackground
        fromLabel.textColor = colorSet.detailsTextColor
        toLabel.textColor = colorSet.detailsTextColor
        
        upImageView.tintColor = colorSet.green
        downImageView.tintColor = colorSet.red
    }
    
    
}

extension DetailsLongSubBlock {
    
    private func setupUI() {
        
        setupImages()
        setupFromLabel()
        setupScaledArrow()
        setupToLabel()
        setupFlowLabels()
        
    }
    
    private func setupFromLabel() {
        self.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fromLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width * 0.03),
            fromLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            fromLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.14),
            fromLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            ])
        
        
        fromLabel.textColor = .white
        fromLabel.font = .systemFont(ofSize: 100)
        fromLabel.adjustsFontSizeToFitWidth = true
        
        
        let attributedText = NSMutableAttributedString(
            string: "1",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        attributedText.append(NSAttributedString(
            string: " ₾",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        fromLabel.attributedText = attributedText
        
    }
    
    private func setupScaledArrow() {
        self.addSubview(arrowScaledView)
        arrowScaledView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            arrowScaledView.leftAnchor.constraint(equalTo: fromLabel.rightAnchor),
            arrowScaledView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowScaledView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.22),
            arrowScaledView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            ])
    }
    
    private func setupToLabel() {
        self.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toLabel.leftAnchor.constraint(equalTo: arrowScaledView.rightAnchor, constant: UIScreen.main.bounds.width * 0.03),
            toLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            toLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -UIScreen.main.bounds.width * 0.22),
            toLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            ])
        
        
        toLabel.font = .systemFont(ofSize: 100)
        toLabel.adjustsFontSizeToFitWidth = true
        
        
        let attributedText = NSMutableAttributedString(
            string: "682.75",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
        
        attributedText.append(NSAttributedString(
            string: " $",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light)]))
        
        toLabel.attributedText = attributedText
        
    }
    
    private func setupImages() {
        self.addSubview(upImageView)
        self.addSubview(downImageView)
        upImageView.translatesAutoresizingMaskIntoConstraints = false
        downImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upImageView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -UIScreen.main.bounds.width * 0.23),
            upImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.width * 0.025),
            upImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            upImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            
            downImageView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -UIScreen.main.bounds.width * 0.23),
            downImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIScreen.main.bounds.width * 0.025),
            downImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            downImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            
        ])
        upImageView.image = UIImage(systemName: "arrow.up")
        downImageView.image = UIImage(systemName: "arrow.down")
        
        upImageView.contentMode = .scaleAspectFit
        downImageView.contentMode = .scaleAspectFit
    }
    
    private func setupFlowLabels() {
        self.addSubview(flowLabel)
        self.addSubview(flowPercentLabel)
        flowLabel.translatesAutoresizingMaskIntoConstraints = false
        flowPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flowLabel.leftAnchor.constraint(equalTo: upImageView.rightAnchor, constant: UIScreen.main.bounds.width * 0.01),
            flowLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.width * 0.025),
            flowLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            flowLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -UIScreen.main.bounds.width * 0.02),
            
            flowPercentLabel.leftAnchor.constraint(equalTo: flowLabel.leftAnchor),
            flowPercentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIScreen.main.bounds.width * 0.025),
            flowPercentLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            flowPercentLabel.rightAnchor.constraint(equalTo: flowLabel.rightAnchor),
        ])
        
        
        flowLabel.text = "0.45 $"
        flowPercentLabel.text = "2.13 %"
        
        flowLabel.font = .systemFont(ofSize: UIScreen.main.bounds.width * 0.03, weight: .light)
        //flowLabel.adjustsFontSizeToFitWidth = true
        flowPercentLabel.font = .systemFont(ofSize: UIScreen.main.bounds.width * 0.03, weight: .light)
        //flowPercentLabel.adjustsFontSizeToFitWidth = true
        
    }
        
    
}
