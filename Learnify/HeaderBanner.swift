//
//  HeaderBanner.swift
//  Learnify
//
//  The colored top band + "Learnify" title repeated at the top of every screen,
//  parameterized by the per-screen accent color (see variables.swift).
//
//  The colored fill ignores the top safe area (bleeds under the status bar /
//  notch) but the title text does not — it's centered on the container's own
//  `height`, laid out separately, so it always keeps equal top/bottom padding
//  regardless of the device's safe-area inset. Applying `.ignoresSafeArea`
//  before centering the text (as this used to do) shifts the centering
//  reference frame upward by the inset, which is what threw the title off.
//
//  `onTap`, when provided, lets the banner double as a "go back to Main" tap
//  target on screens pushed on top of MainPage — those otherwise had no way
//  back if the user changed their mind partway through.
//

import SwiftUI

struct HeaderBanner: View {
    let accentColor: Color
    var title: String = "Learnify"
    let width: CGFloat
    let height: CGFloat
    var onTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            accentColor
                .ignoresSafeArea(edges: .top)

            Text(title)
                .font(.system(size: 48, weight: .black))
                .foregroundStyle(Color.headerTitleText)
        }
        .frame(width: width, height: height)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    HeaderBanner(accentColor: .headerTeal, width: 393, height: 150)
}
