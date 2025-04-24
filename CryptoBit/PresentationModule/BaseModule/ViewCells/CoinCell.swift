//
//  CoinCell.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//

import UIKit

class CoinCell: UITableViewCell {
    
    static let reuseIdentifier = "CoinCell"
    
    @IBOutlet weak var coinTitle: UILabel!
    @IBOutlet weak var coinValue: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinStats: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
