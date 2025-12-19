//
//  AboutPage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 19/12/2025.
//

import SwiftUI

struct AboutPage: View {
    
    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height
            
            ZStack {
                Color(red: 47/255, green: 47/255, blue: 47/255)
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .center) {
                    ZStack {
                        Rectangle()
                            .frame(width: parentWidth, height: 0.2*parentHeight)
                            .foregroundStyle(Color(red: 247/255, green: 179/255, blue: 43/255))
                            .ignoresSafeArea(edges: .top)
                            .overlay(
                                Text("Learnify")
                                    .font(.system(size: 48, weight: .black))
                                    .foregroundStyle(Color(red: 46/255, green: 64/255, blue: 87/255))
                                    .offset(x: 0, y: -0.05*parentHeight)
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 0.2*parentHeight, alignment: .top)
                    
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(red: 60/255, green: 60/255, blue: 60/255))
                            .frame(width: 0.75*parentWidth, height: 0.45*parentHeight)
                            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color(red: 31/255, green: 31/255, blue: 31/255), lineWidth: 4)
                            )
                            .padding(.bottom, 12)
                        
                        VStack {
                            Text("About")
                                .font(Font.largeTitle.bold())
                                .foregroundStyle(Color(red: 222/255, green: 222/255, blue: 222/255))
                                .padding(.top, 20)
                            Text("This app is made by student from AGH University of Science and Technology in Krakow. It is a simple app that helps you to learn new things. You can find more information about it on my [GitHub page](https://github.com/hmielewski/Learnify).")
                                .frame(width: 0.6*parentWidth)
                                .foregroundStyle(Color(red: 222/255, green: 222/255, blue: 222/255))
                                .padding(20)
                        }
                    }
                    
                    Spacer(minLength: 0.1 * parentHeight)
                }
            }
        }
        
    }
}

#Preview {
    AboutPage()
}
