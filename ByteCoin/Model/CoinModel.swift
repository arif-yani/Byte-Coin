//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Muhamad Arif on 13/06/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let assetBase: String
    let assetQuote: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
