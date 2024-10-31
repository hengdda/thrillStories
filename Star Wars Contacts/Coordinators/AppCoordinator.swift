//
//  AppCoordinator.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import Network
class AppCoordinator: Coordinator, CoordinatorProtocol {
    let window: UIWindow
    //@State private var selectedView: Int = Int.random(in: 1...4)
    var cancellables = [String: AnyCancellable]()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    var navigationController: UINavigationController! {
        window.rootViewController as? UINavigationController
    }

    func start() {
        showLaunchScreen()
        DispatchQueue.main.async { [weak self] in
            self?.checkNetwork()
            //self?.showDetailScreen(item)
        }
    }

    private func getInitialItem() -> IndividualModel? {
        let viewModel = IndividualListViewModel()
        viewModel.fetchItems()
        // Assuming the items are stored in an array in the view model
        // Replace 'firstItem' with the actual way to get the item you want to display
        return viewModel.items.first
    }
    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from storyboard")
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible() // Ensure the window is visible
    }

    private func showListScreen() {
        print("Showing list screen") // Add this line to debug
        let viewModel = IndividualListViewModel()
        viewModel.fetchItems()
        cancellables["showList"] = viewModel.didSelectedIndividual
            .sink { [weak self] (item) in
                //When an item is selected, it calls showDetailScreen(_:) to navigate to the detail view of the selected item.
            self?.showDetailScreen(item)
        }

        // Use a UIHostingController as window root view controller
        let view = IndividualListViewNew().environmentObject(viewModel)
        let controller = UIHostingController(rootView: view)
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible() // Ensure the window is visible
    }
  

    private func checkNetwork() {
    
        // Create a monitor to check the network status
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { // Switch to the main thread
                if path.status == .satisfied {
                    let viewModel = IndividualListViewModel()
                    viewModel.fetchItems()
                    self.cancellables["showList"] = viewModel.didSelectedIndividual
                        .sink { [weak self] (item) in
                            self?.showDetailScreen(item)
                        }

                    let view = IndividualListViewNew().environmentObject(viewModel)
                    let controller = UIHostingController(rootView: view)
                    let nav = UINavigationController(rootViewController: controller)
                    nav.navigationBar.isHidden = true
                    self.window.rootViewController = nav
                    self.window.makeKeyAndVisible() // Ensure the window is visible
                } else {
                    print("Network problem, please connect to the local network")
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    private func showDetailScreen(_ item:IndividualModel) {
        let viewModel = IndividualDetailViewModel(model: item)
        cancellables["detailBack"] = viewModel.didNavigateBack
            .sink { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let nextViewIndex = getNextViewIndex()
        let view: AnyView
             
        switch nextViewIndex {
             case 1:
                 view = AnyView(IndividualDetailView3().environmentObject(viewModel))
             case 2:
                 view = AnyView(IndividualDetailView3().environmentObject(viewModel))
             case 3:
                 view = AnyView(IndividualDetailView3().environmentObject(viewModel))
             case 4:
                 view = AnyView(IndividualDetailView3().environmentObject(viewModel))
             default:
                 view = AnyView(IndividualDetailView().environmentObject(viewModel))
             }

        //let view = IndividualDetailView4().environmentObject(viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func getNextViewIndex() -> Int {
          let userDefaults = UserDefaults.standard
          let currentIndex = userDefaults.integer(forKey: "currentViewIndex")
          
          let nextIndex = (currentIndex % 4) + 1
          userDefaults.set(nextIndex, forKey: "currentViewIndex")
          
          return nextIndex
      }
}
