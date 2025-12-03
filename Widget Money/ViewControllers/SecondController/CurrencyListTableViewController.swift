//
//  CurrencyListTableViewController.swift
//  Currency Widget
//
//  Created by macSlm on 03.12.2023.
//

import UIKit
import Foundation
import Combine


protocol CurrencyListViewModelProtocol {
    var rxAppThemeUpdated: Bool { get }
    var colorSet: AppColors { get }

    func findCurrency(str: String)
   
    var rxUpdateRatesFlag: Bool { get }
    var rxCoinListUpdated: Bool { get }
    var showedCoinList: [CurrencyCellViewModel] { get }
    var typeOfCoin: TypeOfCoin { get set }
    
    func selectTail(coin: CurrencyCellViewModel)
    func resetModel()
}


class CurrencyListTableViewController: UIViewController {
    
    var viewModel = CurrencyListViewModelV2(type: .withoutBaseCoin)
    private var cancellables = Set<AnyCancellable>()
    
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat".localized(), "Crypto".localized()])
    var searchBar = UITextField()
    let searchImage = UIImageView()
    
    var tableView = UITableView()
    
    var baseHeightOfElements: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeightOfElements = getBaseHeight()
        
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
        setupUsage()
    }
}

// MARK:  - SETUP USAGE
extension CurrencyListTableViewController {
    
    private func setupUsage(){
        searchBar.delegate = self
        usageTableView()
        usageSegmentedControl()
        usageColors()
    }
    
    private func usageTableView(){
        viewModel.$rxCoinListUpdated.sink { _ in
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func usageSegmentedControl() {
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlChanged(_:)),
            for: .valueChanged
        )
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.typeOfCoin = .fiat
        case 1:
            viewModel.typeOfCoin = .crypto
        default:
            break
        }
        viewModel.resetModel()
    }
    
    
    private func usageColors() {
        viewModel.$rxAppThemeUpdated.sink { flag in
            if flag {
                self.updateColors()
            }
        }.store(in: &cancellables)
    }
}

extension CurrencyListTableViewController {
    private func setupUI(){
        
        setupSegmentedControl()
        setupTextField()
        setupTableView()
        updateColors()

    }
    
    private func updateColors(){
        view.backgroundColor = viewModel.colorSet.background
        tableView.backgroundColor = viewModel.colorSet.background
        
        segmentedControl.configureColors(
            backgroundColor: viewModel.colorSet.backgroundForWidgets,
            segmentColor: viewModel.colorSet.segmentedControlSegment,
            selectedTextColor: viewModel.colorSet.segmentedControlSelectedText,
            secondTextColor: viewModel.colorSet.segmentedControlSecondText
        )
        
        searchBar.layer.borderColor = viewModel.colorSet.separator.cgColor
        
        searchBar.backgroundColor = viewModel.colorSet.background
        searchBar.textColor = viewModel.colorSet.secondText.withAlphaComponent(0.7)
        searchBar.attributedPlaceholder =
        NSAttributedString(string: "Search".localized(), attributes: [NSAttributedString.Key.foregroundColor: viewModel.colorSet.secondText])
        searchImage.tintColor = viewModel.colorSet.secondText
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.keyboardDismissMode = .onDragWithAccessory // Close the keyboard by scrolling
    }
    


    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        
    }
    
    private func setupTextField() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: view.bounds.height*0.02),
            searchBar.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        
        searchBar.layer.cornerRadius = segmentedControl.layer.cornerRadius
        searchBar.layer.borderWidth = 1
        
        searchBar.clearButtonMode = .always
        searchBar.borderStyle = .roundedRect
        searchBar.keyboardType = .default

        
        //Add left view and make it transparent
        searchBar.leftViewMode = .always
        searchBar.leftView?.contentMode = .center
        searchBar.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchBar.leftView?.tintColor = .white.withAlphaComponent(0)
        
        //Setup color of clearButton
        if let clearButton = searchBar.value(forKey: "_clearButton") as? UIButton {
             let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
             clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = viewModel.colorSet.clearButton
         }
        
        //Create custom image view and adding to search bar
        searchImage.image = UIImage(systemName: "magnifyingglass")
        
        searchImage.contentMode = .scaleAspectFit
        self.view.addSubview(searchImage)
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchImage.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: baseHeightOfElements*0.15),
            searchImage.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchImage.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
            searchImage.widthAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
        ])
    }
}

extension CurrencyListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTail(coin: viewModel.showedCoinList[indexPath.row])
    }
}

extension CurrencyListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.showedCoinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyListTableViewCell
        cell.configureWithUniversalCoin(coin: viewModel.showedCoinList[indexPath.row])
        return cell
    }
}

extension CurrencyListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.findCurrency(str: searchText)
        }
}

extension CurrencyListTableViewController {
    
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
}



// MARK:  - SETUP KEYBOARD
extension CurrencyListTableViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}


