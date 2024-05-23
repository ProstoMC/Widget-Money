//
//  ChangeThemeViewController.swift
//  Widget Money
//
//  Created by admin on 09.05.24.
//

import UIKit
import RxSwift

class ChangeThemeViewController: UIViewController {
    
    var previousTheme: AppTheme!
    var saveStatus = false
    
    var settingsList: [ChangeThemeCellViewModel] = []
    var colorSet: AppColors!
    
    let disposeBag = DisposeBag()
    
    var closingLine = UIView()
    
    var headLabel = UILabel()
    var tableView = UITableView()
    var saveButton = UIButton()
    var backButton = UIButton()
    
    var baseHeightOfElements: Double!
    
    override func viewDidLoad() {
        settingsList = createSettingsList()
        previousTheme = CoreWorker.shared.colorsWorker.returnAppTheme()
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupUI()
        rxSubscribing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if saveStatus {
            return
        }
        else {
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: previousTheme)
        }
    }
    
    // MARK:  - RX Subscribing
    private func rxSubscribing() {

        //Update colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe { _ in
            self.changeColorSet()
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.updateColors()
            })

        }.disposed(by: disposeBag)
    }
    
    private func changeColorSet() {
        colorSet = CoreWorker.shared.colorsWorker.returnColors()
        
        for i in settingsList.indices {
            settingsList[i].elementsColor.onNext(colorSet.settingsText)
            settingsList[i].separatorColor.onNext(colorSet.settingsText)
            settingsList[i].backgroundColor.onNext(colorSet.backgroundForWidgets)
        }
        
        settingsList[0].imageName.onNext("sun.max")
        settingsList[1].imageName.onNext("moon")
        settingsList[2].imageName.onNext("gearshape")
        
        switch CoreWorker.shared.colorsWorker.returnAppTheme() {
        case .light:
            settingsList[0].imageName.onNext("sun.max.fill")
            settingsList[0].elementsColor.onNext(colorSet.closingLine)
        case .dark:
            settingsList[1].imageName.onNext("moon.fill")
            settingsList[1].elementsColor.onNext(colorSet.accentColor)
        case .system:
            if colorSet.theme == .dark {
                print ("DARK")
                settingsList[2].elementsColor.onNext(colorSet.accentColor)
            } 
            else {
                print ("LIGHT")
                settingsList[2].elementsColor.onNext(colorSet.closingLine)
            }
            settingsList[2].imageName.onNext("gearshape.fill")
        }
        
    }
    

    
    private func createSettingsList() -> [ChangeThemeCellViewModel] {
        var list: [ChangeThemeCellViewModel] = []
        //Add base coin form CoinList
        list.append(ChangeThemeCellViewModel(
            name: "Light".localized(),
            imageName: BehaviorSubject(value: "sun.max"),
            elementsColor: BehaviorSubject(value: colorSet.settingsText),
            separatorColor: BehaviorSubject(value: colorSet.settingsText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets)))
        
        list.append(ChangeThemeCellViewModel(
            name: "Dark".localized(),
            imageName: BehaviorSubject(value: "moon"),
            elementsColor: BehaviorSubject(value: colorSet.settingsText),
            separatorColor: BehaviorSubject(value: colorSet.settingsText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets))
        )
        list.append(ChangeThemeCellViewModel(
            name: "System".localized(),
            imageName: BehaviorSubject(value: "gearshape"),
            elementsColor: BehaviorSubject(value: colorSet.secondText),
            separatorColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.backgroundForWidgets))
        )
        return list
    }
    
    
}



// MARK:  - SETUP UI
extension ChangeThemeViewController {
    private func setupUI() {
        
        baseHeightOfElements = getBaseHeight()
        setupClosingLine()
        setupHeadLabel()
        setupTableView()
        setupSaveButton()
        setupBackButton()
        updateColors()
    }
    
    private func updateColors(){
        
        view.backgroundColor = colorSet.background
        
        closingLine.backgroundColor = colorSet.closingLine
        
        headLabel.textColor = colorSet.settingsText
        
        tableView.backgroundColor = colorSet.backgroundForWidgets
        
        saveButton.backgroundColor = colorSet.detailsBackground
        saveButton.setTitleColor(colorSet.detailsTextColor, for: .normal)
        
        backButton.setTitleColor(colorSet.secondText, for: .normal)
        
    }
    
    private func setupClosingLine() {
        view.addSubview(closingLine)
        closingLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closingLine.topAnchor.constraint(equalTo: view.topAnchor, constant: baseHeightOfElements/3),
            closingLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closingLine.heightAnchor.constraint(equalToConstant: baseHeightOfElements/8),
            closingLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
        ])
        
        closingLine.layer.cornerRadius = baseHeightOfElements/16
    }
    
    private func setupHeadLabel() {
        view.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            headLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            headLabel.topAnchor.constraint(equalTo: closingLine.bottomAnchor, constant: baseHeightOfElements/3),
            headLabel.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        headLabel.text = "App theme".localized()
        headLabel.textAlignment = .center
        headLabel.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        headLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChangeThemeCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.08),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.08),
            tableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.heightAnchor.constraint(equalToConstant: baseHeightOfElements*4.5) // height of 1 cell is 1.5 of baseHeight. We have 3 cells
        ])
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard by scrolling
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.layer.cornerRadius = UIScreen.main.bounds.height/50
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.5),
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: baseHeightOfElements*1.2),
            saveButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        saveButton.layer.cornerRadius = baseHeightOfElements*0.4
        
        saveButton.setTitle("Save".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        

        
        saveButton.addAction(UIAction { _ in
            self.saveStatus = true
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.35),
            backButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: baseHeightOfElements/2),
            backButton.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5)
        ])
        //backButton.layer.cornerRadius = baseHeightOfElements*0.375
        
        backButton.setTitle("Back".localized(), for: .normal)
        //saveButton.titleLabel?.font = headLabel.font.withSize(baseHeightOfElements*0.5)
        
        backButton.addAction(UIAction { _ in
            self.saveStatus = false
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }
    

}

extension ChangeThemeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 //We just have only 3 types of themes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChangeThemeCell
        
        cell.dataConfigure(viewModel: settingsList[indexPath.row])
        
        //Catch last cell
        if indexPath.row == 2 {
            cell.separatorLine.isHidden = true
        }
        
        return cell
    }
    
}

extension ChangeThemeViewController: UITableViewDelegate {
    
    private func getBaseHeight() -> Double {
        var height = UIScreen.main.bounds.height*0.058
        
        
        if height > 40 {
            height = 40
        } else {
            height = Double(Int(height)) // Deleting fraction
        }
        print (height)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return baseHeightOfElements*1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //Light
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: .light)
        case 1: //Dark
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: .dark)
        case 2: //System
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: .system)
        default:
            return
        }
    }
}


