//
//  HomeViewModel.swift
//  Widget Money
//
//  Created by sloniklm on 26.01.26.
//


import SwiftUI
import Combine

final class HeaderViewModel: ObservableObject {

    @Published var updateText = "Connection error".localized()
    @Published var isOnline = false
    
    var adsBannerID = CoreWorker.shared.adsWorker.returnYABannerID(bannerType: .mainSmallBannerID)

    private var cancellables = Set<AnyCancellable>()

    init() {
        CoreWorker.shared.coinList.rxRateUpdated
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isOnline = CoreWorker.shared.coinList.isOnline

                self.updateText = self.isOnline
                    ? "Updated ".localized() + CoreWorker.shared.coinList.lastUpdate
                    : "Offline! Last update ".localized() + CoreWorker.shared.coinList.lastUpdate
                    
            }
            .store(in: &cancellables)
        
    }
    
    func refreshData() {
        CoreWorker.shared.coinList.updateRatesFromBackend()
    }
    

}
