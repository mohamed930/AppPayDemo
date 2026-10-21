//
//  AppDelegate.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupKeyBoard()
        
        return true
    }

    
    private func setupKeyBoard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardToolbarManager.shared.isEnabled = true
    }
}

