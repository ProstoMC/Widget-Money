//
//  DetailsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 19.12.2023.
//

import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    
    let bag = DisposeBag()
    let viewModel: DetailsViewModelProtocol = DetailsViewModel()
    
    let headBlock = HeadBlockView()
    let favoriteView = UIImageView()
    
    let longBlock = DetailsLongSubBlock()
    let squareBlock100 = DetailsSquareSubBlock()
    let squareBlock1000 = DetailsSquareSubBlock()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
        setupRx()
    }
    
    override func viewWillLayoutSubviews() {
        setupUI()
        //lololo
    }
    
    func configure() {
        headBlock.configure(coinPair: viewModel.pair)
        longBlock.configure(pair: viewModel.pair, colorSet: viewModel.colorSet)
        squareBlock100.configure(pair: viewModel.pair, multiplier: 100)
        squareBlock1000.configure(pair: viewModel.pair, multiplier: 1000)
    }


}

extension DetailsViewController {
    private func setupRx() {
        
        //Appearing of view
        viewModel.rxIsAppearFlag.subscribe { flag in
            self.view.isHidden = !flag
            self.configure()
            print("DETAILS UPDATE")
            print(flag)
        }.disposed(by: bag)
       
        //Favorite status
        viewModel.rxFavoriteStatus.subscribe{ status in
            if status {
                self.favoriteView.image = UIImage(systemName: "suit.heart.fill")
            }
            else {
                self.favoriteView.image = UIImage(systemName: "suit.heart")
            }
        }.disposed(by: bag)
        
        // Behavior
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(tap)
        
        
        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.updateColors()
            }
        }).disposed(by: bag)
        
    }
    
    @objc private func favoriteButtonTapped() {
        do {
            if try self.viewModel.rxFavoriteStatus.value() {
                showAlert(title: "", message: "Delete from favorite".localized())
            } else {
                viewModel.changeFavoriteStatus()
            }
        } catch {
            viewModel.changeFavoriteStatus()
        }
    }
}
// MARK:  - SETUP UI
extension DetailsViewController {
    private func setupUI() {
        
        view.layer.cornerRadius = UIScreen.main.bounds.height/50
        
        setupFavoriteView()
        setupHeadBlock()
        setupLongBlock()
        setupSquaresBlock()
        updateColors()
        
    }
    
    private func updateColors() {
        view.backgroundColor = viewModel.colorSet.detailsBackground
        favoriteView.tintColor = viewModel.colorSet.heartColor
        longBlock.updateColors(colorSet: viewModel.colorSet)
        squareBlock100.updateColors(colorSet: viewModel.colorSet)
        squareBlock1000.updateColors(colorSet: viewModel.colorSet)
    }
    
    private func setupFavoriteView() {
        view.addSubview(favoriteView)
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -UIScreen.main.bounds.width*0.04),
            favoriteView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.width*0.04),
            favoriteView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            favoriteView.widthAnchor.constraint(equalTo: favoriteView.heightAnchor, multiplier: 1.1)
        ])
        
        //favoriteView.image = UIImage(systemName: "suit.heart")
        favoriteView.contentMode = .scaleToFill
        
       
    }
    
    private func setupHeadBlock() {
        headBlock.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headBlock)
        
        NSLayoutConstraint.activate([
            headBlock.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UIScreen.main.bounds.width*0.04),
            headBlock.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.width*0.04),
            headBlock.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            headBlock.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
        
  
    }
    
    private func setupLongBlock() {
        longBlock.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(longBlock)
        
        NSLayoutConstraint.activate([
            longBlock.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UIScreen.main.bounds.width*0.04),
            longBlock.topAnchor.constraint(equalTo: headBlock.bottomAnchor, constant: UIScreen.main.bounds.width*0.04),
            longBlock.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22),
            longBlock.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -UIScreen.main.bounds.width*0.04),
        ])
        
        longBlock.layer.cornerRadius = UIScreen.main.bounds.height/50
        
  
    }
    
    private func setupSquaresBlock() {
        squareBlock100.translatesAutoresizingMaskIntoConstraints = false
        squareBlock1000.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(squareBlock100)
        view.addSubview(squareBlock1000)
        
        NSLayoutConstraint.activate([
            squareBlock100.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UIScreen.main.bounds.width*0.04),
            squareBlock100.topAnchor.constraint(equalTo: longBlock.bottomAnchor, constant: UIScreen.main.bounds.width*0.03),
            squareBlock100.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.width*0.04),
            squareBlock100.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -UIScreen.main.bounds.width*0.015),
            
            squareBlock1000.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -UIScreen.main.bounds.width*0.04),
            squareBlock1000.topAnchor.constraint(equalTo: longBlock.bottomAnchor, constant: UIScreen.main.bounds.width*0.03),
            squareBlock1000.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.width*0.04),
            squareBlock1000.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.width*0.015),
            
        ])
        
        squareBlock100.layer.cornerRadius = UIScreen.main.bounds.height/50
        squareBlock1000.layer.cornerRadius = UIScreen.main.bounds.height/50
        
  
    }

    
    
    
    
    
}
// MARK:  - ALERT
extension DetailsViewController {
    func showAlert(title: String, message: String) {

        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: {_ in
            self.viewModel.changeFavoriteStatus()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
