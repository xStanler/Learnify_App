//
//  AddLanguage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 16/01/2026.
//

import SwiftUI

struct AddLanguage: View {
    @State private var newLanguage: String = ""
    @State private var cardHeight: Int = 0
    @FocusState private var isTopicFieldFocused: Bool?
    
    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height
            
            ZStack {
                Colors.background_color
                    .ignoresSafeArea(edges: .all)
                
                VStack() {
                    ZStack {
                        Rectangle()
                            .frame(width: parentWidth, height: 0.2*parentHeight)
                            .foregroundStyle(Colors.add_logo)
                            .ignoresSafeArea(edges: .top)
                            .overlay(
                                Text("Learnify")
                                    .font(.system(size: 48, weight: .black))
                                    .foregroundStyle(Colors.logo_color)
                                    .offset(x: 0, y: -0.05*parentHeight)
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 0.2*parentHeight, alignment: .top)
                    
                    Spacer()
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20) .fill(Colors.card_background_primary)
                            .frame(width: 0.8*parentWidth, height: 0.3*parentHeight, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(Colors.border_primary, lineWidth: 4)
                                    .frame(maxWidth: 0.8*parentWidth, alignment: .center)
                            )
                        
                        
                        VStack(alignment: .center) {
                            Text("Add Topic")
                                .font(.system(size: 0.05*parentHeight, weight: .medium))
                                .foregroundStyle(Colors.text_primary)
                            
                            TextField("Add topic here", text: $newLanguage)
                                .textFieldStyle(InputStyle())
                                .submitLabel(.done)
                                .focused($isTopicFieldFocused, equals: true)
                                .onSubmit {
                                    isTopicFieldFocused = false;
                                    print($newLanguage)
                                    // call func
                                }
                        }.frame(width: 0.6*parentWidth, height: 0.4*parentHeight)
                            .onChange(of: isTopicFieldFocused) { wasFocused, isFocused in
                                if wasFocused == true && isFocused == false {
                                    // call func
                                }
                            }
                        
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                }
            }
        }
    }
}


#Preview {
    AddLanguage()
}
