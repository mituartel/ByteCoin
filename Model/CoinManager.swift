//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice (coin: String, currency: String)
    func didFailWithErro(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A36D3AC0-357C-47E1-BECE-DE4F3991CC95"
    
    var delegate : CoinManagerDelegate?
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
                   
                   let session = URLSession(configuration: .default)
                   let task = session.dataTask(with: url) { (data, response, error) in
                       if error != nil {
                           self.delegate?.didFailWithErro(error: error!)
                           return
                       }
                       
                       if let safeData = data {
                           
                           if let bitcoinPrice = self.parseJSON(safeData) {
                               
                              
                               let priceString = String(format: "%.2f", bitcoinPrice)
                               
                               
                               self.delegate?.didUpdatePrice(coin: priceString, currency: currency)
                           }
                       }
                   }
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ coinData: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let btc = decodedData.rate
            return btc
        }
        catch {print(error)}
        return 0
        
    }
}

