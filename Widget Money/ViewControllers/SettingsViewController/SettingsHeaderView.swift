//
//  SettingsHeaderView.swift
//  Widget Money
//
//  Created by admin on 04.04.24.
//

import UIKit

class SettingsHeaderView: UIView {

    let logoView = UIImageView()
    let nameLabel = UILabel()
    let versionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        //rxSubscribing()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        //rxSubscribing()
    }
    
    func updateColors(colorSet: AppColors) {
        
        nameLabel.textColor = colorSet.settingsText
        versionLabel.textColor = colorSet.settingsText
        
        if colorSet.theme == .dark {
            logoView.image = UIImage(named: "LogoPinkTransparentV2")
        }
        if colorSet.theme == .light {
            logoView.image = UIImage(named: "LogoBlueTransparentV2")
        }
        
        
    }

}

extension SettingsHeaderView {
    private func setupUI() {
        //backgroundColor = .brown
        setuplogoView()
        setupLabels()
        
    }
    

    
    private func setuplogoView() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
            logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        
        logoView.contentMode = .scaleAspectFit
        
    }
    private func setupLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            versionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            versionLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            versionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06),
            
            nameLabel.bottomAnchor.constraint(equalTo: versionLabel.topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            

        ])
        nameLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width*0.05, weight: .regular) //Just set max and resize after
        
        nameLabel.textAlignment = .center
     
        
        versionLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width*0.04, weight: .light) //Just set max and resize after
        
        versionLabel.textAlignment = .center
        
        nameLabel.text = "Widget Money"
        versionLabel.text = "Version: 1.0"
        
//        nameLabel.backgroundColor = .blue
//        versionLabel.backgroundColor = .brown
        
    }
    
}
