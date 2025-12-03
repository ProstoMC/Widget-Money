//
//  UITapBarController.swift
//  Currency Widget
//
//  Created by macSlm on 15.11.2023.
//

//  It is also Builder of project

import UIKit
import Combine


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var cancellables = Set<AnyCancellable>()
    
    let homeVC = HomeViewController()
    let listVC = SecondViewController()
    let settingsVC = SettingsViewController()
    
    let backgroundView = UIView()
    let topLineView = UIView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBarUI()
        setupViewControllers()
        setupRx()
    }
    
    
    private func setupRx() {
        //Return to first VC
        CoreWorker.shared.exchangeWorker.$rxExchangeFlag.sink{_ in
            self.selectedIndex = 0
        }.store(in: &cancellables)
        //Set active VC
        CoreWorker.shared.$rxViewControllersNumber.sink {index in
            self.selectedIndex = index
        }.store(in: &cancellables)
        
        CoreWorker.shared.colorsWorker.$rxAppThemeUpdated.sink { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.setupTabBarUI()
            })
        }.store(in: &cancellables)
        
    }
    
}

// MARK:  - SETUP UI
extension TabBarViewController {
    
    
    func setupViewControllers() {
        configureHomeVC()
        configureListVC()
        configureSettingsVC()
        viewControllers = [homeVC, listVC, settingsVC]
    }
    
    private func configureHomeVC() {
        let image = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house")
        let item = UITabBarItem(title: "Home".localized(), image: image, selectedImage: selectedImage)
        homeVC.tabBarItem = item
        //homeVC.tabBarSize = self.tabBarController?.tabBar.frame.height ?? 49.0
    }
    
    private func configureListVC() {
        let image = UIImage(systemName: "list.bullet")
        let selectedImage = UIImage(systemName: "list.bullet")
        let item = UITabBarItem(title: "List".localized(), image: image, selectedImage: selectedImage)
        listVC.tabBarItem = item
    }
    
    private func configureSettingsVC() {
        let image = UIImage(systemName: "gear")
        let selectedImage = UIImage(systemName: "gear")
        let item = UITabBarItem(title: "Settings".localized(), image: image, selectedImage: selectedImage)
        settingsVC.tabBarItem = item
    }
    
    
    private func setupTabBarUI() {
        tabBar.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().tabBarBackground
        tabBar.itemPositioning = .centered
        
        tabBar.tintColor = CoreWorker.shared.colorsWorker.returnColors().tabBarText.withAlphaComponent(1)
        tabBar.unselectedItemTintColor = CoreWorker.shared.colorsWorker.returnColors().tabBarText.withAlphaComponent(0.5)
        
        if #available(iOS 18.0, *) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("IPAD")
                return
            }
        }
        print("IPHONE")
        self.view.addSubview(topLineView)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        
        topLineView.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().tabBarLine
        
        
    }
}
