//
//  SettingsTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 28.12.2023.
//

import UIKit
import Combine

class SettingsTableViewCell: UITableViewCell {
    private var cancellables = Set<AnyCancellable>()
    
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    let chevronView = UIImageView()
    
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
        //iconView.image = UIImage(named: viewModel.imageName)
        iconView.image = UIImage(systemName: viewModel.imageName)
        subscribing(viewModel: viewModel)
        
        //print(viewModel.name)
        
    }
    
    func subscribing(viewModel: SettingsCellViewModel){
        viewModel.$value.sink{ value in
            self.valueLabel.text = value
        }.store(in: &cancellables)
        
        // Colors
        viewModel.$backgroundColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.contentView.backgroundColor = color
            })
        }.store(in: &cancellables)
        
        viewModel.$nameLabelColor.sink  { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.nameLabel.textColor = color
                //self.iconView.tintColor = color
            })
        }.store(in: &cancellables)
        
        viewModel.$imageColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.iconView.tintColor = color.withAlphaComponent(0.9)
                //self.iconView.tintColor = color
            })
        }.store(in: &cancellables)
        
        viewModel.$valueLabelColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.valueLabel.textColor = color
                self.separatorLine.backgroundColor = color
                self.chevronView.tintColor = color
            })
        }.store(in: &cancellables)
    }
}

// MARK:  - SETUP UI
extension SettingsTableViewCell {
    private func setupUI() {
        self.selectionStyle = .none
        
        setupIconView()
        setupChevronView()
        setupLabels()
        setupSeparatorLine()
        
    }
    
    private func setupIconView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width / 25),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
        iconView.image = UIImage(systemName: "nosign")
        //iconView.tintColor = .red
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupChevronView() {
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chevronView)
        
        NSLayoutConstraint.activate([
            chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.bounds.width / 25),
            chevronView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            chevronView.widthAnchor.constraint(equalTo: chevronView.heightAnchor)
        ])
        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.contentMode = .scaleAspectFit
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
            
            valueLabel.rightAnchor.constraint(equalTo: chevronView.leftAnchor, constant: -contentView.bounds.width / 50),
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
