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

class CoinCell: UITableViewCell {
    
    private lazy var statHost: UIHostingController<CoinStatView> = {
        let initial = CoinStatView(change: 0, sparkline: [], accentColor: .purple)
        let hc = UIHostingController(rootView: initial)
        hc.view.backgroundColor = .clear
        hc.view.translatesAutoresizingMaskIntoConstraints = false
        
        coinStats.addSubview(hc.view)
        NSLayoutConstraint.activate([
            hc.view.leadingAnchor.constraint(equalTo: coinStats.leadingAnchor),
            hc.view.trailingAnchor.constraint(equalTo: coinStats.trailingAnchor),
            hc.view.topAnchor.constraint(equalTo: coinStats.topAnchor),
            hc.view.bottomAnchor.constraint(equalTo: coinStats.bottomAnchor),
        ])
        
        return hc
    }()
    
    static let reuseIdentifier = "CoinCell"
    
    @IBOutlet weak var coinBackground: UIView!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinStats: UIView!
    @IBOutlet weak var coinPrice: UILabel!
    
    var sparkVals: [Double] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinImage.af.cancelImageRequest()
        coinImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _ = statHost
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with coin: Coin) {
        coinName.text   = coin.name
        coinSymbol.text = coin.symbol
        
        let price = Double(coin.price) ?? 0.0
        
        coinPrice.text =  "$\(String(format: "%.4f", price))"
        
        coinBackground.backgroundColor = (UIColor(hex: coin.color ?? "#FFAA33") ?? .white).withAlphaComponent(0.124)
        
        if let url = coin.iconUrl {
            loadIcon(from: url)
        } else {
            coinImage.image = UIImage(systemName: "bitcoinsign.circle")
        }
        let raw: [Double] = coin.sparklineValues.compactMap(Double.init)
        let dense = raw.interpolated(factor: 14)
        let changePct = Double(coin.change) ?? 0
        let accent = Color(hex: coin.color ?? "#FFAA33")
        
        updateChart(change: changePct, sparkline: raw, accent: accent)
    }
    
    private func loadIcon(from urlStr: String) {
        let pngURL = URL(string: urlStr.replacingOccurrences(of: ".svg", with: ".png"))!
        coinImage.af.setImage(
            withURL: pngURL,
            placeholderImage: UIImage(systemName: "bitcoinsign.circle")
        )
    }
    
    
    private func updateChart(change: Double, sparkline: [Double], accent: Color) {
        statHost.rootView = CoinStatView(
            change: change,
            sparkline: sparkline,
            accentColor: accent
        )
    }
    
}
