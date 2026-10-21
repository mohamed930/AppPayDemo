//
//  MainScreenView.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
