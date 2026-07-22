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
    @StateObject private var router = Router()
    @State private var activePopupLanguage: Database.LanguageRow?
    @State private var pressedLanguageId: Int64?

    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { proxy in
                let parentWidth = proxy.size.width
                let parentHeight = proxy.size.height

                ZStack {
                    Color.learnifyBackground
                        .ignoresSafeArea(edges: .all)

                    VStack {
                        HeaderBanner(accentColor: .headerTeal, width: parentWidth, height: 0.2 * parentHeight)
                            .frame(width: parentWidth, height: 0.2 * parentHeight)
                            .padding(.bottom, 0.05 * parentHeight)
                            .onLongPressGesture {
                                router.push(.settings)
                            }

                        ScrollView {
                            VStack {
                                ForEach(viewModel.languages, id: \.id) { row in
                                    languageTile(row, parentWidth: parentWidth, parentHeight: parentHeight)
                                }

                                addLanguageTile(parentWidth: parentWidth, parentHeight: parentHeight)
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                            .padding(.horizontal, 20)
                        }
                        .onAppear() {
                            self.viewModel.load()
                        }
                    }

                    if let activePopupLanguage {
                        LanguageActionsPopup(
                            languageName: activePopupLanguage.name,
                            onAddCard: {
                                self.activePopupLanguage = nil
                                router.push(.addCard(languageId: activePopupLanguage.id, languageName: activePopupLanguage.name))
                            },
                            onEditCards: {
                                self.activePopupLanguage = nil
                                router.push(.editLanguage(languageId: activePopupLanguage.id, languageName: activePopupLanguage.name))
                            },
                            onMegaLesson: {
                                self.activePopupLanguage = nil
                                router.push(.learning(.mega))
                            },
                            onDeleteLanguage: {
                                self.activePopupLanguage = nil
                                deleteLanguage(activePopupLanguage)
                            },
                            onDismiss: {
                                self.activePopupLanguage = nil
                            }
                        )
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .addLanguage:
                    AddLanguagePage()
                case .editLanguage(let languageId, let languageName):
                    EditLanguagePage(languageId: languageId, languageName: languageName)
                case .addCard(let languageId, let languageName):
                    AddCardPage(languageId: languageId, languageName: languageName)
                case .learning(let scope):
                    LearningPage(scope: scope)
                case .settings:
                    SettingsPage()
                }
            }
        }
        .environmentObject(router)
    }

    @ViewBuilder
    private func languageTile(_ row: Database.LanguageRow, parentWidth: CGFloat, parentHeight: CGFloat) -> some View {
        let isPressed = pressedLanguageId == row.id

        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(isPressed ? Color.cardSurfacePressed : Color.cardSurface)
            .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 4)
                    .overlay(
                        Text(row.name)
                            .font(Font.largeTitle.bold())
                            .foregroundStyle(Color.primaryText)
                    )
            )
            .padding(.bottom, 12)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: isPressed)
            .onTapGesture {
                router.push(.learning(.language(id: row.id, name: row.name)))
            }
            .onLongPressGesture(
                minimumDuration: 0.5,
                maximumDistance: 50,
                perform: {
                    activePopupLanguage = row
                },
                onPressingChanged: { pressing in
                    pressedLanguageId = pressing ? row.id : nil
                }
            )
    }

    @ViewBuilder
    private func addLanguageTile(parentWidth: CGFloat, parentHeight: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.cardSurface)
            .frame(width: 0.75*parentWidth, height: 0.15*parentHeight)
            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 4)
                    .overlay(
                        Text("+")
                            .font(Font.largeTitle.bold())
                            .foregroundStyle(Color.primaryText)
                    )
            )
            .padding(.bottom, 12)
            .onTapGesture {
                router.push(.addLanguage)
            }
    }

    private func deleteLanguage(_ language: Database.LanguageRow) {
        if let words = try? Database.fetchWords(languageId: language.id) {
            for word in words {
                if let image = word.helpImage {
                    ImageStore.delete(image)
                }
            }
        }
        try? Database.deleteLanguage(id: language.id)
        viewModel.load()
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
