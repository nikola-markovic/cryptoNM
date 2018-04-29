//
//  DetailNavBar.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/25/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit

class DetailNavBar: UIViewController {

    @IBOutlet weak var imgV : UIImageView!
    @IBOutlet weak var symbolLbl : UILabel!

    @IBOutlet weak var topBar_H : NSLayoutConstraint!
    
    @IBOutlet weak var loading : UIActivityIndicatorView!
    
    var reloadTimer = Timer()
    
    var detailVC : DetailsVC!
    var historyVC : HistoryVC!

    var selectedCurrencyInfo : CurrencyInfo!
    let compareCurrencies = ["BTC", "ETH", "EVN", "DOGE", "ZEC", "USD", "EUR"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgV.af_setImage(withURL: URL(string: CryptoDB.main.cryptoWebURL + selectedCurrencyInfo.imageUrl)!)
        self.symbolLbl.text = selectedCurrencyInfo.symbol
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getPrices() {
        self.reloadTimer.invalidate()
        self.loading.startAnimating()
        
        CryptoDB.main.getPriceFor(currency: selectedCurrencyInfo.symbol,
                                  converted: compareCurrencies.joined(separator: ","))
        { (gathered) in
            if gathered != nil {
                self.detailVC.comparePrices = gathered!
                self.detailVC.tableV_H.constant = CGFloat(gathered!.count * 50)
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
                self.detailVC.tableV.reloadData()
            } else {
                // TO DO: Show error
            }
            self.loading.stopAnimating()
            self.reloadTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (_) in
                self.getPrices()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBar" {
            self.detailVC = (segue.destination as! DetailTabController).viewControllers![0] as! DetailsVC
            self.detailVC.detailNavBar = self
            self.detailVC.selectedCurrencyInfo = self.selectedCurrencyInfo
            
            self.historyVC = (segue.destination as! DetailTabController).viewControllers![1] as! HistoryVC
            self.historyVC.detailNavBar = self
            self.historyVC.selectedCurrencyInfo = self.selectedCurrencyInfo
            
            (segue.destination as! DetailTabController).detailNavBar = self
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reloadTimer.invalidate()
    }
    
    deinit {
        print("released.")
    }
}
