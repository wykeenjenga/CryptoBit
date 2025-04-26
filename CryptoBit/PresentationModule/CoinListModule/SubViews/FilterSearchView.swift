//
//  FilterSearchView.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//


import SwiftUI

struct FilterSearchView: View {
  @ObservedObject var viewModel: HomeViewModel
  
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                SearchBarView(viewModel: viewModel)
            }
            .padding(.horizontal)
        }
    }
    
    
}
