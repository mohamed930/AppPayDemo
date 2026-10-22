//
//  DashedDivider.swift
//  AppPayDemo
//
//  Created by Mohamed Ali on 22/10/2026.
//

import SwiftUI

struct DashedDivider: View {
    var body: some View {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 1000, y: 0))
        }
        .stroke(
            Color.gray.opacity(0.2),
            style: StrokeStyle(
                lineWidth: 2,
                lineCap: .round,
                dash: [0.1, 5]
            )
        )
        .frame(height: 2)
    }
}
