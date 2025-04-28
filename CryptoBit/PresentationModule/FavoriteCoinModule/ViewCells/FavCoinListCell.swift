//
//  CoinCell.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//

import UIKit
import SwiftUI
import Alamofire
import AlamofireImage

class FavCoinListCell: UITableViewCell {
    
    static let reuseIdentifier = "FavCoinListCell"
    
    @IBOutlet weak var coinBackground: UIView!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinImage: UIImageView!

    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinImage.af.cancelImageRequest()
        coinImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with favorite: FavoriteCoin) {
        coinName.text   = favorite.name
        coinSymbol.text = favorite.symbol
        
        coinBackground.backgroundColor =
        (UIColor(hex: "#FFAA33") ?? .white).withAlphaComponent(0.124)
        
        if let urlStr = favorite.iconUrl,
           let pngURL = URL(string: urlStr.replacingOccurrences(of: ".svg", with: ".png")){
            coinImage.af.setImage(withURL: pngURL,
                                  placeholderImage: UIImage(systemName: "bitcoinsign.circle"))
        } else {
            coinImage.image = UIImage(systemName: "bitcoinsign.circle")
        }
    }
    
    
}
