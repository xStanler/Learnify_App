//
//  AboutPage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 19/12/2025.
//

import SwiftUI

struct AboutPage: View {
    @Binding var selectedPage: Int

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height
            
            ZStack {
                Colors.background_color
                .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .center) {
                    ZStack {
                        Rectangle()
                            .frame(width: parentWidth, height: 0.2*parentHeight)
                            .foregroundStyle(Colors.about_logo)
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
                    
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Colors.card_background_primary)
                            .frame(width: 0.75*parentWidth, height: 0.45*parentHeight)
                            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Colors.border_primary, lineWidth: 4)
                            )
                            .padding(.bottom, 12)
                        
                        VStack {
                            Text("About")
                                .font(Font.largeTitle.bold())
                                .foregroundStyle(Colors.text_primary)
                                .padding(.top, 20)
                            Text("This app is made by student from AGH University of Science and Technology in Krakow. It is a simple app that helps you learn new things. You can find more information about it on my [GitHub page](https://github.com/xStanler/Learnify_App.git).")
                                .frame(width: 0.6*parentWidth)
                                .foregroundStyle(Colors.text_primary)
                                .padding(20)
                        }
                    }
                    
                    Spacer(minLength: 0.2 * parentHeight)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Colors.card_background_primary)
                    .frame(width: 105, height: 105)
                    .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Colors.border_primary, lineWidth: 6)
                            .overlay(
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundStyle(Colors.main_logo)
                            )
                    )
                    .padding(.trailing, 25)
                    .onTapGesture {
                        selectedPage = 0
                    }
            }
        }
        
    }
}

extension AboutPage {
    init(previewSelected initial: Int = 0) {
        self._selectedPage = .constant(initial)
    }
}

#Preview {
    AboutPage(previewSelected: 0)
}
