//
//  AlertView.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import SwiftUI


struct AlertView: View {
    var params: AlertParams
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(params.status.img)
                .resizable()
                .scaledToFit()
                .frame(width: 65)

            Text(params.amount)
                .setFont(fontName: .mainFontBold, size: 28)

            Text(params.status.paymentStatusMessage)
                .setFont(fontName: .mainFontSemiBold, size: 14)
                .foregroundStyle(Color(params.status.color))

            DashedDivider()

            LineComponets(
                title: "Reference number",
                value: params.reference
            )

            LineComponets(
                title: "Date",
                value: params.date
            )

            LineComponets(
                title: "Pay with",
                value: "Pay with  Pay"
            )
            .padding(.bottom, 12)

            Button(action: onDismiss) {
                Text("Ok")
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(params.status.color))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                    .setFont(fontName: .mainFontBold, size: 20)
            }
            .padding(.bottom, 12)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 12)
    }
}


#Preview {
    AlertView(params: AlertParams(amount: "20,000 EGP",
                                  reference: "42342343243",
                                  date: "20/06/2020 13:05",
                                  status: .success)) {
        
    }
}
