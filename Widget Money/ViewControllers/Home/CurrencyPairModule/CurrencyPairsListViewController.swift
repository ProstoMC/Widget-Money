//
//  TileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit
import RxSwift


// MARK:  - Setup sections for RxDataSource

// MARK:  ViewController

class CurrencyPairsListViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var viewModel: CurrencyPairsListViewModelProtocol!
    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrencyPairsListViewModel()

        setupUI()
        subscribing()
    }
    
    //For reordering cells
    @objc private func handleLongPressGR(gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func subscribing() {
        
        viewModel.rxPairsUpdated.subscribe(onNext: { _ in
            self.collectionView.reloadData()
        }).disposed(by: bag)

        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.updateColors()
            }
        }).disposed(by: bag)
      
    }

    
    // MARK: - Collection View Appearing
    private func setupUI() {
        setupCollectionView()
        updateColors()
    }
    
    private func updateColors() {
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       options: [.allowUserInteraction], animations: { () -> Void in
            self.view.backgroundColor = self.viewModel.colorSet.background
            self.collectionView.backgroundColor = self.viewModel.colorSet.background
        })
    }

    private func setupCollectionView(){
        
        //Set horisontal scrolling
        lazy var flowLayout: UICollectionViewFlowLayout = {
            let f = UICollectionViewFlowLayout()
            f.scrollDirection = UICollectionView.ScrollDirection.horizontal
            return f
        }()
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        //Setup space before first element (x2 then between elements)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.bounds.width / 25, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CurrencyPairCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        //For reordering cells
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGR(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
    }
}

// MARK:  - CollectionView Appearing

extension CurrencyPairsListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //Size of elements
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height*0.92, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width / 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Select action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CurrencyPairCell {
            viewModel.selectTail(indexPath: indexPath)
            cell.contentView.backgroundColor = viewModel.colorSet.mainColorPale
            UIView.animate(withDuration: 1.0, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                cell.contentView.backgroundColor = self.viewModel.colorSet.backgroundForWidgets
            })
        }
    }
    
    //MARK: - REORDERING
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.reorderPair(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
}
    //MARK: - DATA SOURCE
extension CurrencyPairsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pairList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CurrencyPairCell
        cell.rxConfigure(currecnyPair: viewModel.pairList[indexPath.row], colors: self.viewModel.colorSet)
        return cell
    }
    
    
}

