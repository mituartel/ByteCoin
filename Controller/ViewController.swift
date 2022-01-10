//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {
 



    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyLabel.text = "AUD"
        
       
        
    }

   
    
}


extension ViewController: UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencySelected = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencySelected)
        currencyLabel.text = coinManager.currencyArray[row]
    }
    
}

extension ViewController: CoinManagerDelegate{
    
    func didUpdatePrice(coin: String, currency: String) {
        DispatchQueue.main.async {
       self.bitcoinLabel.text = coin
            self.currencyLabel.text = currency
            
        }
    }
    
    func didFailWithErro(error: Error) {
        print(error)
    }
    
}
