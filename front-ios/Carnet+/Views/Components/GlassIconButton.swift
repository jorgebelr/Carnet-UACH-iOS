//
//  GlassIconButton.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 09/03/26.
//

import SwiftUI

struct GlassIconButton: View {
    
    var systemName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
