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
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack(alignment: .center) {
                    HeaderBanner(accentColor: .headerAmber, width: parentWidth, height: 0.2 * parentHeight)
                        .frame(maxWidth: .infinity, maxHeight: 0.2*parentHeight, alignment: .top)

                    Spacer()

                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.cardSurface)
                            .frame(width: 0.75*parentWidth, height: 0.45*parentHeight)
                            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.cardBorder, lineWidth: 4)
                            )
                            .padding(.bottom, 12)

                        VStack {
                            Text("About")
                                .font(Font.largeTitle.bold())
                                .foregroundStyle(Color.primaryText)
                                .padding(.top, 20)
                            Text("This app is made by student from AGH University of Science and Technology in Krakow. It is a simple app that helps you to learn new things. You can find more information about it on my [GitHub page](https://github.com/hmielewski/Learnify).")
                                .frame(width: 0.6*parentWidth)
                                .foregroundStyle(Color.primaryText)
                                .padding(20)
                        }
                    }

                    Spacer(minLength: 0.2 * parentHeight)
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
