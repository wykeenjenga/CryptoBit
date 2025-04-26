//
//  CoinStatView.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 24/04/2025.
//


import SwiftUI
import Charts

struct CoinStatView: View {
    let change: Double
    let sparkline: [Double]
    let accentColor: Color
    
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                accentColor.opacity(0.7),
                accentColor.opacity(0.3),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    
    private var yDomain: ClosedRange<Double> {
       let minY = sparkline.min() ?? 0
       let maxY = sparkline.max() ?? 1
       return minY...maxY
     }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
                Text(String(format: "%.1f%%", abs(change)))
            }
            .font(.caption.weight(.semibold))
            .foregroundColor(accentColor)
            
            Chart {
                if sparkline.count > 1 {
                    ForEach(Array(sparkline.enumerated()), id: \.0) { idx, val in
                        AreaMark(
                            x: .value("Index", idx),
                            y: .value("Value", val)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(gradient.opacity(0.2))
                    }
                }
                
                ForEach(Array(sparkline.enumerated()), id: \.0) { idx, val in
                    LineMark(
                        x: .value("Index", idx),
                        y: .value("Value", val)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                    .foregroundStyle(gradient)
                }
                
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartYScale(domain: yDomain) 
            .frame(height: 25)
        }
        .padding(8)
    }
}

