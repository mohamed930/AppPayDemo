//
//  UIViewController.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 16/10/2024.
//

import UIKit
import SwiftUI

extension UIViewController {
    
    func addHosting<Content: View>(_ swiftUI: Content) {
        
        self.view.backgroundColor = .back
            
        navigationController?.isNavigationBarHidden = true
        
        // Create a UIHostingController with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUI)

        // Add the hosting controller as a child
        addChild(hostingController)
        view.addSubview(hostingController.view)

        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Notify child
        hostingController.didMove(toParent: self)
    }
}
