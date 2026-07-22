//
//  SettingsPage.swift
//  Learnify
//
//  Reached by long-pressing the "Learnify" logo on Main Page — keeps the
//  entry point out of the way rather than adding another small icon button.
//

import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject private var router: Router
    @AppStorage("lessonLength") private var lessonLength: Double = 20

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack {
                    HeaderBanner(
                        accentColor: .headerSettings,
                        title: "Settings",
                        width: parentWidth,
                        height: 0.2 * parentHeight
                    ) {
                        router.popToRoot()
                    }
                    .frame(width: parentWidth, height: 0.2 * parentHeight)

                    Spacer()

                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.cardSurface)
                        .frame(width: 0.85*parentWidth, height: 0.24*parentHeight)
                        .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.cardBorder, lineWidth: 4)
                        )
                        .overlay(
                            VStack(spacing: 12) {
                                Text("Lesson Length")
                                    .font(Font.title3.bold())
                                    .foregroundStyle(Color.primaryText)

                                Text("\(Int(lessonLength)) words")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundStyle(Color.headerSettings)

                                Slider(value: $lessonLength, in: 5...30, step: 1)
                                    .tint(Color.headerSettings)
                                    .padding(.horizontal, 8)
                            }
                            .padding(24)
                        )

                    Spacer()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SettingsPage()
            .environmentObject(Router())
    }
}
