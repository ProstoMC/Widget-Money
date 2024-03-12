//
//  NameAndCountryBlock.swift
//  Widget Money
//
//  Created by  slm on 27.02.2024.
//

import UIKit

class NameAndCountryBlock: UIView {
    let nameLabel = UILabel()
    let countryLabel = UILabel()
    
    var lenghtOfText: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(name: String) {
        let localizedName = name.localized()
        
        var wordsArray = localizedName.components(separatedBy: " ")

        nameLabel.text = wordsArray.last
        
        wordsArray.removeLast()
        
        var country = ""
        for word in wordsArray {
            country = country + word + " "
        }
        
        countryLabel.text = country
        
        //lenghtOfText = countryLabel.intrinsicContentSize.width
    }
    
    func setupUI() {
        
        self.addSubview(nameLabel)
        self.addSubview(countryLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            
            //countryLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            countryLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            countryLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            countryLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: self.bounds.height*0.5),
        ])
        
        nameLabel.text = "Lari"
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: UIScreen.main.bounds.height*0.035)
        //nameLabel.adjustsFontSizeToFitWidth = true
        lenghtOfText = countryLabel.intrinsicContentSize.width
        
        countryLabel.text = "Georgian"
        countryLabel.font = .systemFont(ofSize: UIScreen.main.bounds.height*0.015, weight: .light)
        countryLabel.textColor = .white.withAlphaComponent(0.8)
        //countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.numberOfLines = 2
        countryLabel.lineBreakMode = .byTruncatingTail
        //countryLabel.backgroundColor = .brown
        
    }
    
}

