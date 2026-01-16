//
//  rootPage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 21/12/2025.
//

import SwiftUI

struct rootPage: View {
    @State private var selectedPage = 0
    
    var body: some View {
        TabView(selection: $selectedPage) {
            AboutPage(selectedPage: $selectedPage)
                .tag(1)
            MainPage(selectedPage: $selectedPage)
                .tag(0)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(edges: .all)
        .background(background_color)
    }
}

#Preview {
    rootPage()
}
