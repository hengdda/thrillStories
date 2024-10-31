//
//  IndividualListViewModel.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import protocol SwiftUI.ObservableObject
import Combine
import CoreGraphics
import UIKit
//import UIKit

class IndividualListViewModel: ObservableObject {
    let didSelectedIndividual = PassthroughSubject<IndividualModel, Never>()
    let directoryService: DirectoryServiceProtocol
    let imageStore: ImageStoreProtocol

    @Published private(set) var items = [IndividualModel]()
    @Published private(set) var error: Error? = nil

    init(items: [IndividualModel] = [], resolver: DependencyResolver = DependencyContainer.resolver) {
        self.items = items
        self.directoryService = resolver.resolve()
        self.imageStore = resolver.resolve()
    }

    func fetchItems() {
        directoryService.fetchDirectory(handleDirectoryResult)
    }
    func selectItem(item: IndividualModel) {
        didSelectedIndividual.send(item)
    }
    func fetchImageIfNeeded(item: IndividualModel) {
        let key = item.profilePictureLookupKey
        if imageStore.hasImage(for: key) { return }
        directoryService.fetchData(item.profilePictureURL) { [weak self] result in
            self?.handleImageDataResult(key, result)
        }
    }

    func getImageold(for item: IndividualModel) -> CGImage {
        let key = item.profilePictureLookupKey
        return imageStore.getImage(for: key) ?? Theme.defaultImage
    }
    func getImage(for item: IndividualModel) -> CGImage {
        let key = item.profilePictureLookupKey
        if let cachedImage = imageStore.getImage(for: key) {
            return cachedImage
        } else if let localImage = UIImage(named: key)?.cgImage {
            return localImage
        } else {
            return Theme.defaultImage
        }
    }
    func handleImageDataResult(_ key:ImageID, _ result:Result<Data, Error>) {
        switch result {
        case .success(let data):
            self.objectWillChange.send()
            self.imageStore.addImage(for: key, data: data)
        case .failure(let error):
            self.error = error
        }
    }

    func handleDirectoryResult(result: DirectoryResult) {
        switch result {
        case .success(let items):
            self.items = items
           // print("selfitems: \(self.items)")
        case .failure(let error):
            print("ERROR: \(error)")
        }
    }


}
