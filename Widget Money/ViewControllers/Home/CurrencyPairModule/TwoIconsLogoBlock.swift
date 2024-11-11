//
//  TwoIconsLogoBlock.swift
//  Widget Money
//
//  Created by admin on 28.10.24.
//

import UIKit


class TwoIconsLogoBlock: UIView {
    let mainIcon = UIImageView()
    let baseIcon = UIImageView()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let mainRadius = mainIcon.frame.height/2
        let baseRadius = baseIcon.frame.height/2

        mainIcon.layer.masksToBounds = true
        baseIcon.layer.masksToBounds = true
        
        mainIcon.layer.cornerRadius = mainRadius
        baseIcon.layer.cornerRadius = baseRadius
    }
    
    func configure(mainImageURL: String?, baseImageURL: String?) {
        guard let mainUrl = URL(string: mainImageURL ?? "Error") else {
            print ("No image")
            return
        }
        guard let baseUrl = URL(string: baseImageURL ?? "Error") else {
            print ("No image")
            return
        }
        let placeHolder = UIImage(systemName: "gyroscope")
        
        mainIcon.sd_setImage(with: mainUrl, placeholderImage: placeHolder)
        baseIcon.sd_setImage(with: baseUrl, placeholderImage: placeHolder)
        //logoImageView.tintColor = colors.tabBarBackground
        
        mainIcon.contentMode = .scaleAspectFit
        baseIcon.contentMode = .scaleAspectFit
    }
}

extension TwoIconsLogoBlock {
    private func setupUI() {
        mainIcon.translatesAutoresizingMaskIntoConstraints = false
        baseIcon.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(baseIcon)
        self.addSubview(mainIcon)
        
        NSLayoutConstraint.activate([
            mainIcon.topAnchor.constraint(equalTo: self.topAnchor),
            mainIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            mainIcon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            
            baseIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            baseIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            baseIcon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55),
            ])
        
        mainIcon.contentMode = .scaleAspectFit
        baseIcon.contentMode = .scaleAspectFit
        
    }
}
