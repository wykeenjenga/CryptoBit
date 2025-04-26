//
//  CoinDetailView.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//


import SwiftUI
import Charts
import Combine
import Alamofire
import AlamofireImage

// MARK: - Detail Screen for a Coin
struct CoinDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: CoinDetailViewModel
    
    
    init(uuid: String) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(uuid: uuid))
    }

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 24) {
                
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        headerSection
                        
                        let accent = Color(hex: viewModel.detail?.color ?? "#FFAA33")
                        
                        VStack(alignment: .leading, spacing: 14) {
                            
                            CoinDetailedChartView(sparkline: viewModel.sparkline ?? [], accentColor: accent)
                            
                            rangePickerSection
                                .padding()
                        }
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color.white)
//                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                        )
                        
                        if let description = viewModel.detail?.description {
                            descriptionSection(text: description)
                        }
                        
                        statisticsSection
                        
                        Spacer(minLength: 16)
                    }
                    .padding(.top)
                }
                
                HStack(spacing: 4) {
                    ActionButton(
                        title: "Buy & Sell",
                        systemIcon: "arrow.left.arrow.right",
                        variant: .primary
                    ) {
                        // buy & sell action
                    }
                    
                    Spacer()

                    ActionButton(
                        title: "Transfer",
                        systemIcon: "paperplane.fill",
                        variant: .secondary
                    ) {
                        // transfer action
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        ///.ignoresSafeArea()
//        .background(
//            Color.gray.opacity(0.08).ignoresSafeArea()
//        )
        .onAppear {
            viewModel.fetchDetail()
        }
    }
    
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
    }


    // MARK: - Sections
    private var headerSection: some View {
        VStack(alignment: .center, spacing: 16) {
            
            if let iconUrl = viewModel.detail?.iconUrl{
                let url = URL(string: iconUrl.replacingOccurrences(of: ".svg", with: ".png"))!
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color(hex: viewModel.detail?.color ?? "#FFAA33").opacity(0.124))
                }
            }
            
            Text(viewModel.detail?.name ?? "Loading...")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            let price = Double(viewModel.detail?.price ?? "") ?? 0.0
            
            Text("$\(String(format: "%.2f", price))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            let changePct = Double(viewModel.detail?.change ?? "0") ?? 0
            
            HStack(spacing: 2) {
                Image(systemName: changePct >= 0 ? "arrow.up" : "arrow.down")
                    .imageScale(.large)
                Text(String(format: "%.1f%%", abs(changePct)))
                    .font(.headline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .font(.caption.weight(.semibold))
            .foregroundColor(Color(hex: viewModel.detail?.color ?? "#FFAA33"))
            .background {
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color(hex: viewModel.detail?.color ?? "#FFAA33").opacity(0.124))
            }
        }
        .padding()

    }
    
    private var rangePickerSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TimeRange.allCases) { range in
                    Button(action: {
                        viewModel.selectedRange = range
                    }) {
                        Text(range.displayName)
                            .font(.subheadline).bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                viewModel.selectedRange == range
                                ? Color.accentColor
                                : Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                viewModel.selectedRange == range
                                ? .white
                                : .primary
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 4)
    }
}


extension CoinDetailView {
    private func descriptionSection(text: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    // MARK: – Statistics Grid
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.headline)

            LazyVGrid(
                columns: [
                  GridItem(.flexible(), spacing: 12),
                  GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                StatCard(label: "Market Cap", value: viewModel.detail?.marketCap ?? "--")
                StatCard(label: "24H Volume", value: viewModel.detail?.volume24h ?? "--")
                StatCard(label: "Change", value: viewModel.detail?.change ?? "--")
                StatCard(label: "Rank", value: "\(viewModel.detail?.rank ?? 0)")
                StatCard(label: "Max Supply", value: viewModel.detail?.supply?.max ?? "--")
                StatCard(label: "All-Time High", value: viewModel.detail?.allTimeHigh?.price ?? "--")
            }
        }
        .padding()
    }
}


struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
        )
    }
}
