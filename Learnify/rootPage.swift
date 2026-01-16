//
//  rootPage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 21/12/2025.
//

import SwiftUI

struct rootPage: View {
    @State private var selectedPage = 0
    @State private var showAddLanguage = false
    
    var body: some View {
        TabView(selection: $selectedPage) {
            AboutPage(selectedPage: $selectedPage)
                .tag(1)
            MainPage(selectedPage: $selectedPage, onAddTapped: { showAddLanguage = true })
                .tag(0)
        }
        .fullScreenCover(isPresented: $showAddLanguage) {
            AddLanguage()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(edges: .all)
        .background(Colors.background_color)
    }
}

#Preview {
    rootPage()
}
