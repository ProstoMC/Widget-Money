//
//  SettingsTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 28.12.2023.
//

import UIKit
import RxSwift

class SettingsTableViewCell: UITableViewCell {
    let bag = DisposeBag()
    
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    
    let separatorLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //setupUI()
    }
    
    func dataConfigure(viewModel: SettingsCellViewModel) {
        nameLabel.text = viewModel.name
        
        if viewModel.name == "Base currency".localized() {
            iconView.image = UIImage(named: "SettingsCurrency")
            iconView.tintColor = .systemIndigo
        }
        if viewModel.name == "App theme".localized() {
            iconView.image = UIImage(named: "SettingsTheme")
            iconView.tintColor = .systemMint
            separatorLine.isHidden = true
        }
        
        subscribing(viewModel: viewModel)
        
    }
    
    func subscribing(viewModel: SettingsCellViewModel){
        viewModel.value.subscribe(onNext: { value in
            self.valueLabel.text = value
        }).disposed(by: bag)
        
        // Colors
        viewModel.backgroundColor.subscribe(onNext: { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.contentView.backgroundColor = color
            })
        }).disposed(by: bag)
        
        viewModel.nameLabelColor.subscribe(onNext: { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.nameLabel.textColor = color
            })
        }).disposed(by: bag)
        
        viewModel.valueLabelColor.subscribe(onNext: { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.valueLabel.textColor = color
                self.separatorLine.backgroundColor = color
            })
        }).disposed(by: bag)
    }
}

// MARK:  - SETUP UI
extension SettingsTableViewCell {
    private func setupUI() {
        
        self.selectionStyle = .none
        
        setupIconView()
        setupLabels()
        setupSeparatorLine()
        
    }
    
    private func setupIconView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width*0.02),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
        iconView.image = UIImage(systemName: "nosign")
        iconView.tintColor = .red
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupLabels() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: contentView.bounds.width / 25),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.bounds.width / 25),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        

        
        valueLabel.textAlignment = .right
    }
    
    private func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLine.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        
        
    }
}
