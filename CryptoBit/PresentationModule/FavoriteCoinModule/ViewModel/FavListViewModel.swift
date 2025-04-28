//
//  FavListViewModel.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//


import Foundation
import Combine
import CoreData

final class FavListViewModel: ObservableObject {
    @Published private(set) var favorites: [FavoriteCoin] = []
    @Published var errorMessage: String?

    private let context = CoreDataManager.shared.context
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchFavorites()
        
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] _ in
                self?.fetchFavorites()
            }
            .store(in: &cancellables)
    }

    func fetchFavorites() {
        let req: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
        do {
            favorites = try context.fetch(req)
        } catch {
            errorMessage = error.localizedDescription
            favorites = []
        }
    }

    func remove(_ favorite: FavoriteCoin) {
        context.delete(favorite)
        CoreDataManager.shared.saveContext()
        fetchFavorites()
    }
}
