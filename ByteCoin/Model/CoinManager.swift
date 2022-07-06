//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7214C14F-C73E-4980-BC89-6D556E5F4ACB"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
//        performRequest(with: urlString)
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString!)
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
//    func performRequest(with urlString: String) {
//
//    }
//
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()

        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let assetBase = decodeData.asset_id_base
            let assetQuote = decodeData.asset_id_quote
            let rate = decodeData.rate

            let coin = CoinModel(assetBase: assetBase, assetQuote: assetQuote, rate: rate)
            
            
            return coin


        } catch {
            delegate?.didFailWithError(error: error)

            return nil
        }
    }
    
    

    
}
