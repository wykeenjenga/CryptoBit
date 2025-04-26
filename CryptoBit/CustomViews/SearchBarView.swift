//
//  SearchBar.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//

import SwiftUI
import Combine

struct SearchBarView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    @FocusState var isKeyboardShowing: Bool
    @State var showEdit: Bool = false
    @State var addContacts: Bool = false
    @State var showDelete: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            searchBarView
        }
    }
    
    
    var searchBarView: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundColor(.accentColor)
            
            TextField(text: $viewModel.searchText, prompt: Text("Search cryptos").foregroundColor(.gray).font(.subheadline)) {
                EmptyView()
            }
            .autocorrectionDisabled()
            .focused($isKeyboardShowing)
            .frame(width: 240)
            .onChange(of: self.viewModel.searchText) { oldValue, newValue in
                self.viewModel.searchText = newValue
                viewModel.onSearch(with: newValue)
            }
            .submitLabel(.search)
            
            Spacer()
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                    if isKeyboardShowing {
                        withAnimation {
                            isKeyboardShowing.toggle()
                        }
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(.secondary)
                }
            }
            
            
            Menu {
              Button {
                viewModel.sortByPriceDescending()
              } label: {
                Label("Price ↓", systemImage: "dollarsign.circle.fill")
              }
              Button {
                viewModel.sortByChangeDescending()
              } label: {
                Label("24 h ↓", systemImage: "clock.arrow.2.circlepath")
              }
            } label: {
              Image(systemName: "line.horizontal.3.decrease.circle")
                .imageScale(.large)
                .foregroundColor(.black)
                .frame(width: 50)
            }
            
        }
        .padding(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12))
        .font(.headline)
        .background {
            Capsule()
                .fill(Color.white)
                .shadow(color: Color(uiColor: .systemGray5) , radius: 5, x: 0, y: 0)
        }
    }
}
