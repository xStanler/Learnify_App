//
//  variables.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 16/01/2026.
//

import Foundation
import SwiftUI

// COLORS
struct Colors {
    static let background_color = Color(red: 47/255, green: 47/255, blue: 47/255)

    static let text_primary = Color(red: 222/255, green: 222/255, blue: 222/255)
    static let text_secondary = Color(red: 153/255, green: 153/255, blue: 153/255)

    static let border_primary = Color(red: 31/255, green: 31/255, blue: 31/255)
    static let border_secondary = Color(red: 51/255, green: 51/255, blue: 51/255)

    static let card_background_primary = Color(red: 60/255, green: 60/255, blue: 60/255)
    static let card_background_secondary = Color(red: 85/255, green: 85/255, blue: 85/255)

    static let logo_color = Color(red: 46/255, green: 64/255, blue: 87/255)
    static let main_logo = Color(red: 117/255, green: 185/255, blue: 190/255)
    static let about_logo = Color(red: 247/255, green: 179/255, blue: 43/255)
    static let add_logo = Color(red: 213/255, green: 195/255, blue: 196/255)

    static let right_color = Color(red: 85/255, green: 224/255, blue: 80/255)
    static let wrong_color = Color(red: 224/255, green: 80/255, blue: 80/255)
}

// VIEWS AND STYLES
struct InputStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Colors.card_background_secondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Colors.border_secondary, lineWidth: 2)
            )
            .foregroundStyle(Color.white)
    }
}
