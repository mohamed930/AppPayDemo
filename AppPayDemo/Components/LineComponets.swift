//
//  LineComponets.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import SwiftUI

struct LineComponets: View {
    
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .setFont(fontName: .mainFontMeduim, size: 14)
                .foregroundStyle(Color.gray)
            
            Spacer()
            
            Text(value)
                .setFont(fontName: .mainFontBold, size: 14)
        }
    }
}

#Preview {
    var title: String = "Hello"
    var value: String = "World"
    LineComponets(title: title, value: value)
}
