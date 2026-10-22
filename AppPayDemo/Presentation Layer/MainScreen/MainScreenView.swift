//
//  MainScreenView.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 21/10/2026.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @FocusState private var isAmountFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            Text("Pick how to pay")
                .frame(maxWidth: .infinity,alignment: .leading)
                .setFont(fontName: .mainFontBold, size: 22)
            
            Text("You'll only be charged after the ride")
                .setFont(fontName: .mainFontMeduim, size: 14)
                .padding(.bottom,16)
            
            ZStack(alignment: .leading) {
                
                TextField("Enter the Amount to recharge", text: $viewModel.txt)
                    .keyboardType(.asciiCapableNumberPad)
                    .focused($isAmountFocused)
                    .onChange(of: isAmountFocused) { isFocused in
                        if !isFocused {
                            viewModel.addPrefixPriceAndCurrncy()
                        }
                        else {
                            viewModel.isVoilatedValidation = false
                        }
                    }
                    .setFont(fontName: .mainFontMeduim, size: 16)
                    .foregroundStyle(viewModel.isVoilatedValidation ? .red : .text)
                    .padding()
                    .padding(.horizontal,30)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.isVoilatedValidation ? .red : .gray.opacity(0.23), lineWidth: 1)
                    }
                
                Image(systemName: "creditcard")
                    .padding(.horizontal)
                    .setFont(fontName: .mainFontMeduim, size: 16)
            }
            .padding(.bottom,viewModel.isVoilatedValidation ? -2 : 16)
            
            if viewModel.isVoilatedValidation {
                Text("Your charge shouldn't be 0.0 EGP")
                    .setFont(fontName: .mainFontMeduim, size: 12)
                    .foregroundStyle(Color.red)
                    .padding(.bottom,10)
            }
                
            Text("Note: Promo code requires a payment method")
                .setFont(fontName: .mainFontBold, size: 13)
                .frame(maxWidth: .infinity,alignment: .center)
                .foregroundStyle(Color.gray)
                .padding(.bottom,2)
            
            HStack {
                Image(systemName: "lock")
                
                Text("Your payment info will be stored securely")
            }
            .setFont(fontName: .mainFontBold, size: 13)
            .foregroundStyle(Color.gray)
            .frame(maxWidth: .infinity,alignment: .center)
            .padding(.bottom,16)
            
            ApplePayButton {
                isAmountFocused = false
                viewModel.validateApplePayButtonAction()
            }
            .frame(maxHeight: 50)
            .disabled(viewModel.isProcessingPayment)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical,20)
        .padding(.horizontal,20)
        .customAlert(presenter: viewModel.alertPresenter)
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel(useCases: PaymentUseCases(respotery: PaymentRespotery())))
}
