//
//  ResultPage.swift
//  Learnify
//
//  Full-screen right/wrong feedback shown after answering a card. Tap anywhere
//  to continue to the next card, matching the "cursor-pointer" affordance on
//  these screens in the Figma design.
//

import SwiftUI

struct ResultPage: View {
    let isCorrect: Bool
    let onContinue: () -> Void

    private var accentColor: Color { isCorrect ? .headerGreen : .headerRed }
    private var iconName: String { isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill" }
    private var message: String { isCorrect ? "You're right !" : "You're wrong" }

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack {
                    HeaderBanner(accentColor: accentColor, width: parentWidth, height: 0.2 * parentHeight)
                        .frame(width: parentWidth, height: 0.2 * parentHeight)

                    Spacer()

                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.cardSurface)
                        .frame(width: 0.75*parentWidth, height: 0.4*parentHeight)
                        .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.cardBorder, lineWidth: 4)
                        )
                        .overlay(
                            VStack(spacing: 16) {
                                Image(systemName: iconName)
                                    .font(.system(size: 60))
                                    .foregroundStyle(accentColor)
                                Text(message)
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundStyle(accentColor)
                            }
                        )

                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onContinue)
    }
}

#Preview {
    ResultPage(isCorrect: true) {}
}
