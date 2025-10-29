//
//  ContentView.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 17/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "book")
                .font(.system(size: 72))
                .foregroundColor(.red)
            Text("Welcome in Learnify!")
            Rectangle.init()
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
