//
//  MainScreenViewController.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import UIKit
import SwiftUI

class MainScreenViewController: UIViewController {
    
    private let viewmodel = MainScreenViewModel(useCases: PaymentUseCases(respotery: PaymentRespotery()))

    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(MainScreenView(viewModel: viewmodel))
    }

}
