//
//  CoinDetailedChartView.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import Charts
import Combine
import Alamofire
import AlamofireImage

struct CoinDetailedChartView: View {
    
    let sparkline: [Double]
    let accentColor: Color
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [
                accentColor.opacity(0.7),
                accentColor.opacity(0.3),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    

    private var baseline: Double {
        sparkline.min() ?? 0
    }
    
    var yDomain: ClosedRange<Double> {
        let minY = sparkline.min() ?? 0
        let maxY = sparkline.max() ?? 1
        return minY...maxY
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            ZStack {
                withAnimation {
                    
                    Chart {
                        
                        ForEach(Array(sparkline.enumerated()), id: \.0) { idx, val in
                            LineMark(
                                x: .value("Index", idx),
                                y: .value("Value", val)
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                            .foregroundStyle(
                              .linearGradient(
                                Gradient(colors: [
                                  accentColor.opacity(0.7),
                                  accentColor.opacity(0.3)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                              )
                            )
                        }
                        
                        ForEach(Array(sparkline.enumerated()), id: \.0) { idx, val in
                            AreaMark(
                               x: .value("Index", idx),
                               yStart: .value("Baseline", sparkline.min() ?? 0),
                               yEnd: .value("Value", val)
                             )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(gradient.opacity(0.124))
                            
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartYScale(domain: yDomain)
                    .frame(height: 160)
                }

            }

            
        }
        .padding(8)
    }


}

