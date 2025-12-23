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
    @StateObject private var viewModel = MainPageViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height
            
            ZStack {
                Color(red: 47/255, green: 47/255, blue: 47/255)
                    .ignoresSafeArea(edges: .all)
                
                VStack() {
                    ZStack {
                        Rectangle()
                            .frame(width: parentWidth, height: 0.2*parentHeight)
                            .foregroundStyle(Color(red: 117/255, green: 185/255, blue: 190/255))
                            .ignoresSafeArea(edges: .top)
                            .padding(.bottom, 0.05*parentHeight)
                            .overlay(
                            Text("Learnify")
                                .font(.system(size: 48, weight: .black))
                                .foregroundStyle(Color(red: 46/255, green: 64/255, blue: 87/255))
                                .offset(x: 0, y: -0.05*parentHeight)
                        )
                    }
                    .frame(width: parentWidth, height: 0.2*parentHeight)
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.languages, id: \.id) { row in
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color(red: 60/255, green: 60/255, blue: 60/255))
                                    .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
                                    .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color(red: 31/255, green: 31/255, blue: 31/255), lineWidth: 4)
                                            .overlay(
                                                Text(row.name)
                                                    .font(Font.largeTitle.bold())
                                                    .foregroundStyle(Color(red: 222/255, green: 222/255, blue: 222/255))
                                            )
                                    )
                                    .padding(.bottom, 12)
                            }
                            
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(red: 60/255, green: 60/255, blue: 60/255))
                                .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
                                .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color(red: 31/255, green: 31/255, blue: 31/255), lineWidth: 4)
                                        .overlay(
                                            Text("+")
                                                .font(Font.largeTitle.bold())
                                                .foregroundStyle(Color(red: 222/255, green: 222/255, blue: 222/255))
                                        )
                                )
                                .padding(.bottom, 12)
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.horizontal, 20)
                        
                        
                    }
                    .onAppear() {
                        self.viewModel.load()
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(red: 60/255, green: 60/255, blue: 60/255))
                        .frame(width: 105, height: 105)
                        .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color(red:31/255, green: 31/255, blue: 31/255), lineWidth: 6)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 24, weight: .black))
                                        .foregroundStyle(Color(red: 247/255, green: 179/255, blue: 43/255, opacity: 0.75))
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
}
