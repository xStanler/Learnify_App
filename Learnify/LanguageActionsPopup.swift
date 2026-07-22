//
//  LanguageActionsPopup.swift
//  Learnify
//
//  Shown when a language tile on Main Page is long-pressed: lets the user add
//  or edit that language's cards, jump into a mega lesson spanning every
//  language, or delete the language — without cluttering the tile itself
//  with small icon buttons.
//

import SwiftUI

struct LanguageActionsPopup: View {
    let languageName: String
    let onAddCard: () -> Void
    let onEditCards: () -> Void
    let onMegaLesson: () -> Void
    let onDeleteLanguage: () -> Void
    let onDismiss: () -> Void

    @State private var isConfirmingDelete = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture(perform: onDismiss)

            if isConfirmingDelete {
                confirmDeleteCard
            } else {
                actionsCard
            }
        }
    }

    private var actionsCard: some View {
        VStack(spacing: 16) {
            Text(languageName)
                .font(Font.title2.bold())
                .foregroundStyle(Color.primaryText)
                .padding(.top, 24)

            actionRow(title: "Add New Cards", action: onAddCard)
            actionRow(title: "Edit Cards", action: onEditCards)
            actionRow(title: "Start Mega Lesson", action: onMegaLesson)
            actionRow(title: "Delete Language", action: { isConfirmingDelete = true }, destructive: true)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .frame(width: 280)
        .background(popupBackground)
    }

    private var confirmDeleteCard: some View {
        VStack(spacing: 16) {
            Text("Delete \(languageName)?")
                .font(Font.title3.bold())
                .foregroundStyle(Color.headerRed)
                .padding(.top, 24)
                .multilineTextAlignment(.center)

            Text("This removes all of its cards. This can't be undone.")
                .font(.footnote)
                .foregroundStyle(Color.promptText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            HStack(spacing: 12) {
                Button(action: { isConfirmingDelete = false }) {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.inputSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.inputBorder, lineWidth: 3)
                                )
                        )
                }

                Button(action: onDeleteLanguage) {
                    Text("Delete")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.headerRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.inputSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.headerRed.opacity(0.7), lineWidth: 3)
                                )
                        )
                }
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .frame(width: 280)
        .background(popupBackground)
    }

    private var popupBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.cardSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 4)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
    }

    @ViewBuilder
    private func actionRow(title: String, action: @escaping () -> Void, destructive: Bool = false) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(destructive ? Color.headerRed : Color.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.inputSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(destructive ? Color.headerRed.opacity(0.6) : Color.inputBorder, lineWidth: 3)
                        )
                )
        }
    }
}

#Preview {
    LanguageActionsPopup(
        languageName: "French",
        onAddCard: {},
        onEditCards: {},
        onMegaLesson: {},
        onDeleteLanguage: {},
        onDismiss: {}
    )
}
