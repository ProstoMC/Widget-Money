//
//  SettingsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import UIKit
import RxSwift
import GoogleMobileAds

class SettingsViewController: UIViewController {
    
    //AdMob block ID
    //Tests:
    let adsBlockID = "ca-app-pub-3940256099942544/2435281174"
    //Prodaction
    //let adBlockID = "ca-app-pub-7946769692194601/4341308255"
    
    var viewModel: SettingsViewModelProtocol = SettingsViewModel()
    let disposeBag = DisposeBag()
    
    var headerView: SettingsHeaderView!
    var topline: UIView!
    var tableView: UITableView!
    
    var adsBlock = GADBannerView()
    
    var baseHeightOfElements: Double!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeightOfElements = getBaseHeight()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        rxSubscribing()
    }
    
    // MARK:  - RX Subscribing
    private func rxSubscribing() {

        //Update colors
        viewModel.rxAppThemeUpdated.subscribe { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.colorsUpdate()
            })

        }.disposed(by: disposeBag)
    }

}
extension SettingsViewController: ReturnDataFromChooseViewControllerProtocol {
    func passCurrencyShortName(name: String?) {
        if name != nil {
            viewModel.changeBaseCurrency(name: name!)
        }
    }
}
// MARK:  - SEUP UI
extension SettingsViewController {
    private func setupUI() {
        
        setupHeaderView()
        setupTopLine()
        setupTableView()
        setupAdsBlock()
        
        colorsUpdate()
    }
    
    private func setupHeaderView() {
        
        headerView = SettingsHeaderView(frame: CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height*0.5)
        )
        
        view.addSubview(headerView)
        
    }
    
    private func setupTopLine() {
        topline = UIView(frame: CGRect(
            x: view.bounds.width / 25,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width - view.bounds.width / 25,
            height: 1)
        )
        
        view.addSubview(topline)
        
        
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: CGRect(
            x: view.bounds.width*0.04,
            y: topline.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width * 0.92,
            height: baseHeightOfElements*3) // 1 row = 1.5 BaseHeigh. We have 2 rows
        )
        view.addSubview(tableView)
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = UIScreen.main.bounds.height/80
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard with scrolling
        
    }
    
    private func setupAdsBlock() {
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width*0.92)
        adsBlock = GADBannerView(adSize: adSize)

        adsBlock.rootViewController = self
        
        adsBlock.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adsBlock)
        
        NSLayoutConstraint.activate([
            adsBlock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adsBlock.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50)
        ])
        
        adsBlock.adUnitID = adsBlockID
        adsBlock.load(GADRequest())
        
    }

    
    private func colorsUpdate() {
        view.backgroundColor = viewModel.colorSet.background
        topline.backgroundColor = viewModel.colorSet.background
        tableView.backgroundColor = viewModel.colorSet.backgroundForWidgets
        headerView.updateColors(colorSet: viewModel.colorSet)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.settingsList.count)
        return viewModel.settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        cell.dataConfigure(viewModel: viewModel.settingsList[indexPath.row])
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
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
        //Base currency
        if indexPath.row == 0 { changeBaseCurrency() }
        //App theme
        if indexPath.row == 1 { changeThemeAlert() }
    }
    

    
    
}



// MARK:  - CELL TAPPED
extension SettingsViewController {
    func changeBaseCurrency() {
        let vc = ChooseCurrencyViewController()
        vc.modalPresentationStyle = .automatic
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func changeThemeAlert() {

        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "System".localized(), style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .system)
        })
        )
        alert.addAction(UIAlertAction(title: "Light".localized(), style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .light)
        })
        )
        alert.addAction(UIAlertAction(title: "Dark".localized(), style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .dark)
        })
        )
        //For IPADS
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:  - SETUP KEYBOARD
extension SettingsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

