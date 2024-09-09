//
//  SettingsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import UIKit
import RxSwift
import GoogleMobileAds
import SwiftUI
import StoreKit
import YandexMobileAds
import YandexMobileAdsInstream

class SettingsViewController: UIViewController {
    
    var viewModel: SettingsViewModelProtocol = SettingsViewModel()
    let disposeBag = DisposeBag()
    
    var headerView: SettingsHeaderView!
    var topline: UIView!
    var tableView: UITableView!
    
    //var adsBlock = GADBannerView()
    
    //YANDEX AD BANNER
    
    private lazy var yaAdsBlock: AdView = {
        let width = view.safeAreaLayoutGuide.layoutFrame.width*0.92
        let adSize = BannerAdSize.stickySize(withContainerWidth: width)
        
        let adView = AdView(adUnitID: viewModel.bannerID, adSize: adSize)
        //adView.accessibilityIdentifier = CommonAccessibility.bannerView
        adView.delegate = self
        return adView
    }()
    
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
        
        viewModel.rxAdsIsHidden.subscribe(onNext: { isHidden in
            self.yaAdsBlock.isHidden = isHidden
        }).disposed(by: disposeBag)
        
        viewModel.rxSettingsListUpdated.subscribe(onNext: { flag in
            if flag {
                self.setupTableView()
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
    }
    

}
extension SettingsViewController: ReturnDataFromChooseViewControllerProtocol {
    
    func passCurrencyShortName(name: String?) {
        if name != nil {
            viewModel.changeBaseCurrency(name: name!)
        }
    }
}
// MARK:  - SETUP UI
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
            height: view.bounds.height*0.45)
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
            height: baseHeightOfElements*Double(viewModel.settingsList.count)*1.5) // 1 row = 1.5 BaseHeigh.
        )
        
        view.addSubview(tableView)
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        tableView.layer.cornerRadius = UIScreen.main.bounds.height/80
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard with scrolling
        
    }
    
    private func setupAdsBlock() {
        
        //YANDEX
        yaAdsBlock.translatesAutoresizingMaskIntoConstraints = false
        yaAdsBlock.loadAd()

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
        //print(viewModel.settingsList.count)
        return viewModel.settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        cell.dataConfigure(viewModel: viewModel.settingsList[indexPath.row])
        
        //Delete separator in last cell
        
        if indexPath.row == viewModel.settingsList.count - 1 {
            cell.separatorLine.isHidden = true
        }
        
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
        //print (height)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return baseHeightOfElements*1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Base currency
        if indexPath.row == 0 { changeBaseCurrency() }
        //App theme
        if indexPath.row == 1 { changeTheme() }
        //Purchases
        if indexPath.row > 1 { goToPurchase(index: indexPath.row) }
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
    
    func changeTheme() {
        let vc = ChangeThemeViewController()
        vc.colorSet = viewModel.colorSet
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    func goToPurchase(index: Int) {
        guard let product: Product = viewModel.returnProduct(id: viewModel.settingsList[index].productID ?? "") else {return}
        let vc = UIHostingController(rootView: PurchaseUI(product: product, colorSet: viewModel.colorSet))
        //vc.configure(productID: viewModel.settingsList[index].imageName) //image name is Product ID
        //vc.colorSet = viewModel.colorSet
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
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

// MARK: - YANDEX ADS

extension SettingsViewController: AdViewDelegate {
    func showAd() {
        view.addSubview(yaAdsBlock)
        NSLayoutConstraint.activate([
            yaAdsBlock.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            yaAdsBlock.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func adViewDidLoad(_ adView: AdView) {
        showAd()
    }
}


