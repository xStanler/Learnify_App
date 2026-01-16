//
//  AddLanguage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 16/01/2026.
//

import SwiftUI

struct AddLanguage: View {
    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height
            
            ZStack {
                background_color
                    .ignoresSafeArea(edges: .all)
                
                VStack() {
                    ZStack {
                        Rectangle()
                            .frame(width: parentWidth, height: 0.2*parentHeight)
                            .foregroundStyle(add_logo)
                            .ignoresSafeArea(edges: .top)
                            .overlay(
                                Text("Learnify")
                                    .font(.system(size: 48, weight: .black))
                                    .foregroundStyle(logo_color)
                                    .offset(x: 0, y: -0.05*parentHeight)
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 0.2*parentHeight, alignment: .top)
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20) .fill(card_background_primary)
                            .frame(maxWidth: 0.8*parentWidth, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(border_primary, lineWidth: 4)
                                    .frame(maxWidth: 0.8*parentWidth, alignment: .center)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Add Topic")
                                .font(.system(size: 0.05*parentHeight, weight: .medium))
                                .foregroundStyle(text_primary)
                            
                            Text("You can add a new language here")
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    AddLanguage()
}
