//
//  MainPage.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 03/12/2025.
//

import SwiftUI

let db = Database.connection

struct MainPage: View {
    @Binding var selectedPage: Int
    var onAddTapped: (() -> Void)? = nil
    @StateObject private var viewModel = MainPageViewModel()
    
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
                            .foregroundStyle(Colors.main_logo)
                            .ignoresSafeArea(edges: .top)
                            .padding(.bottom, 0.05*parentHeight)
                            .overlay(
                            Text("Learnify")
                                .font(.system(size: 48, weight: .black))
                                .foregroundStyle(Colors.logo_color)
                                .offset(x: 0, y: -0.05*parentHeight)
                        )
                    }
                    .frame(width: parentWidth, height: 0.2*parentHeight)
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.languages, id: \.id) { row in
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Colors.card_background_primary)
                                    .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
                                    .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Colors.border_primary, lineWidth: 4)
                                            .overlay(
                                                Text(row.name)
                                                    .font(Font.largeTitle.bold())
                                                    .foregroundStyle(Colors.text_primary)
                                            )
                                    )
                                    .padding(.bottom, 12)
                            }
                            
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Colors.card_background_primary)
                                .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
                                .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Colors.border_primary, lineWidth: 4)
                                        .overlay(
                                            Text("+")
                                                .font(Font.largeTitle.bold())
                                                .foregroundStyle(Colors.text_primary)
                                        )
                                )
                                .padding(.bottom, 12)
                                .onTapGesture {
                                    onAddTapped?()
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.horizontal, 20)
                        
                        
                    }
                    .onAppear() {
                        self.viewModel.load()
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Colors.card_background_primary)
                        .frame(width: 105, height: 105)
                        .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Colors.border_primary, lineWidth: 6)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 24, weight: .black))
                                        .foregroundStyle(Colors.about_logo)
                                )
                        )
                        .padding(.leading, 25)
                        .onTapGesture {
                            selectedPage = 1
                        }
                }
            }
        }
    }
}

extension MainPage {
    init(previewSelected initial: Int = 0) {
        self._selectedPage = .constant(initial)
    }
}

#Preview {
    MainPage(previewSelected: 0)
        .environmentObject(MainPageViewModel())
}
