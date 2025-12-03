//
//  ChangeThemeCell.swift
//  Widget Money
//
//  Created by admin on 12.05.24.
//

import UIKit
import Combine

class ChangeThemeCellViewModel {
    init(name: String, imageName: String, elementsColor: UIColor, separatorColor: UIColor, backgroundColor: UIColor) {
        self.name = name
        self.imageName = imageName
        self.elementsColor = elementsColor
        self.separatorColor = separatorColor
        self.backgroundColor = backgroundColor
    }
    let name: String
    @Published var imageName: String
    
    @Published var elementsColor: UIColor
    @Published var separatorColor: UIColor
    @Published var backgroundColor: UIColor
}

class ChangeThemeCell: UITableViewCell {
    
    
    private var cancellables = Set<AnyCancellable>()
    
    let iconView = UIImageView()
    let nameLabel = UILabel()
    
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
    
    func dataConfigure(viewModel: ChangeThemeCellViewModel) {
        nameLabel.text = viewModel.name
        subscribing(viewModel: viewModel)
    }
    
    func subscribing(viewModel: ChangeThemeCellViewModel){
        // Image
        viewModel.$imageName.sink { name in
            self.iconView.image = UIImage(systemName: name)
            
        }.store(in: &cancellables)
        // Colors
        viewModel.$backgroundColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.contentView.backgroundColor = color
            })
        }.store(in: &cancellables)
        
        viewModel.$elementsColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.nameLabel.textColor = color
                self.iconView.tintColor = color
            })
        }.store(in: &cancellables)
        
        viewModel.$separatorColor.sink { color in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.separatorLine.backgroundColor = color
            })
        }.store(in: &cancellables)
    }
}

// MARK:  - SETUP UI
extension ChangeThemeCell {
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
            iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width / 25),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
        iconView.image = UIImage(systemName: "nosign")
        iconView.tintColor = .red
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupLabels() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: contentView.bounds.width / 25),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
        ])
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
