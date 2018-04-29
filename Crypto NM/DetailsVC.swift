//
//  DetailsVC.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/25/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var fullNameLbl : UILabel!
    @IBOutlet weak var algorithmLbl : UILabel!
    @IBOutlet weak var preMinedValueLbl : UILabel!
    @IBOutlet weak var fullyPreminedLbl: UILabel!
    @IBOutlet weak var proofTypeLbl : UILabel!
    @IBOutlet weak var totalCoinSupplyLbl : UILabel!
    @IBOutlet weak var totalCoinsFreeFloatLbl : UILabel!
    @IBOutlet weak var sponsoredLbl : UILabel!
    @IBOutlet weak var tradingStatusV : UIView!
    
    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var scrollV : UIScrollView!
    @IBOutlet weak var contentV : UIView!
    
    @IBOutlet weak var tableV_H : NSLayoutConstraint!
    
    var selectedCurrencyInfo : CurrencyInfo!
    
    var comparePrices = [Price]()
    weak var detailNavBar : DetailNavBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableV_H.constant = 0
        populateSubviews()
        self.detailNavBar.getPrices()
    }
    
    func populateSubviews() {
        self.fullNameLbl.text = selectedCurrencyInfo.fullName
        self.algorithmLbl.text = selectedCurrencyInfo.algorithm
        self.preMinedValueLbl.text = selectedCurrencyInfo.preMinedValue
        self.fullyPreminedLbl.text = selectedCurrencyInfo.fullyPremined ? "YES" : "NO"
        self.proofTypeLbl.text = selectedCurrencyInfo.proofType
        self.totalCoinSupplyLbl.text = "\(selectedCurrencyInfo.totalCoinSupply)"
        self.totalCoinsFreeFloatLbl.text = selectedCurrencyInfo.totalCoinsFreeFloat
        self.sponsoredLbl.text = selectedCurrencyInfo.sponsored ? "YES" : "NO"
        if selectedCurrencyInfo.isTrading {
            tradingStatusV.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        } else {
            tradingStatusV.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.05610767772, alpha: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        DispatchQueue.main.async {
            var h: CGFloat = 100.0 + 140
            
            for v in self.contentV.subviews {
                h += v.frame.size.height
            }
            self.scrollV.contentSize = CGSize(width: self.view.frame.width, height: h)
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comparePrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableV.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceCell
        cell.configureCellFor(price: comparePrices[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 70 {
            self.detailNavBar.topBar_H.constant = 140 - scrollView.contentOffset.y
        } else {
            self.detailNavBar.topBar_H.constant = 70
        }
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        print(CryptoDB.main.cryptoWebURL + selectedCurrencyInfo.url)
        if UIApplication.shared.canOpenURL(URL(string: CryptoDB.main.cryptoWebURL + selectedCurrencyInfo.url)!) {
            UIApplication.shared.open(URL(string: CryptoDB.main.cryptoWebURL + selectedCurrencyInfo.url)!, options: [:], completionHandler: nil)
        }
    }
}

class PriceCell : UITableViewCell {
    @IBOutlet weak var currencyLbl : UILabel!
    @IBOutlet weak var valueLbl : UILabel!
    
    func configureCellFor(price: Price) {
        self.currencyLbl.text = price.currency
        
        var sym = "$ "
        switch price.currency {
        case "EUR":
            sym = "€ "
            break
        case "ETH":
            sym = "Ξ "
            break
        case "EVN":
            sym = "Ë "
            break
        case "DOGE":
            sym = "Ð "
            break
        case "ZEC":
            sym = "Ż "
            break
        case "BTC":
            sym = "₿ "
            break
        default:
            break
        }
        
        self.valueLbl.text = sym + price.value

    }
}
