//
//  variables.swift
//  Learnify
//
//  Global variables — colors reused across every screen. Values match the
//  Figma design (https://www.figma.com/design/Yqkth5HaZdxXrRVgVi4l8O/LearnifyApp).
//

import SwiftUI

extension Color {
    // Base surfaces
    static let learnifyBackground = Color(red: 47 / 255, green: 47 / 255, blue: 47 / 255)
    static let cardSurface = Color(red: 60 / 255, green: 60 / 255, blue: 60 / 255)
    static let cardSurfacePressed = Color(red: 42 / 255, green: 42 / 255, blue: 42 / 255)
    static let cardBorder = Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
    static let inputSurface = Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255)
    static let inputBorder = Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255)

    // Text
    static let headerTitleText = Color(red: 46 / 255, green: 64 / 255, blue: 87 / 255)
    static let primaryText = Color(red: 222 / 255, green: 222 / 255, blue: 222 / 255)
    static let promptText = Color(red: 187 / 255, green: 187 / 255, blue: 187 / 255)
    static let placeholderText = Color(red: 153 / 255, green: 153 / 255, blue: 153 / 255)

    // Per-screen header accents
    static let headerTeal = Color(red: 117 / 255, green: 185 / 255, blue: 190 / 255)   // Main
    static let headerRose = Color(red: 213 / 255, green: 195 / 255, blue: 196 / 255)   // Add/Edit Language, Add Card
    static let headerAmber = Color(red: 247 / 255, green: 179 / 255, blue: 43 / 255)   // About
    static let headerGreen = Color(red: 85 / 255, green: 224 / 255, blue: 80 / 255)    // Correct answer
    static let headerRed = Color(red: 224 / 255, green: 80 / 255, blue: 80 / 255)      // Wrong answer

    // Per-language lesson header accents — one language always maps to the same
    // color (see LearningPage.lessonAccentColor), so revisiting a language's
    // lesson feels consistent. Same muted/dusty saturation-lightness family as
    // headerTeal/headerRose, kept distinct from the vivid amber/green/red used
    // for About and right/wrong feedback so those meanings don't get muddied.
    static let lessonPalette: [Color] = [
        Color(red: 117 / 255, green: 185 / 255, blue: 190 / 255),  // dusty teal
        Color(red: 155 / 255, green: 143 / 255, blue: 201 / 255),  // dusty lavender
        Color(red: 199 / 255, green: 167 / 255, blue: 92 / 255),   // dusty mustard
        Color(red: 176 / 255, green: 124 / 255, blue: 158 / 255),  // dusty mauve
        Color(red: 111 / 255, green: 160 / 255, blue: 201 / 255),  // dusty sky blue
        Color(red: 143 / 255, green: 174 / 255, blue: 138 / 255),  // dusty sage
    ]

    // The mega lesson (all languages combined) gets its own fixed, distinct accent.
    static let megaLessonAccent = Color(red: 192 / 255, green: 133 / 255, blue: 82 / 255)  // dusty copper

    // Settings screen — a neutral, desaturated slate blue, distinct from every
    // other screen's accent so it reads as app-level chrome rather than content.
    static let headerSettings = Color(red: 120 / 255, green: 132 / 255, blue: 148 / 255)
}
