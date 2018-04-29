//
//  CurrencyCell.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/24/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit
import AlamofireImage

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var imgV : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var symbolLbl : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFor(currency: CurrencyInfo) {
        self.imgV.image = nil
        self.nameLbl.text = ""
        self.symbolLbl.text = ""
        
        self.imgV.af_setImage(withURL: URL(string: CryptoDB.main.cryptoWebURL + currency.imageUrl)!)
        self.nameLbl.text = currency.coinName
        self.symbolLbl.text = currency.symbol
    }
}
