//
//  AddLanguagePage.swift
//  Learnify
//

import SwiftUI

struct AddLanguagePage: View {
    @EnvironmentObject private var router: Router
    @State private var topicName = ""
    @State private var errorMessage: String?

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack {
                    HeaderBanner(accentColor: .headerRose, title: headerTitle, width: parentWidth, height: 0.2 * parentHeight) {
                        router.popToRoot()
                    }
                    .frame(width: parentWidth, height: 0.2 * parentHeight)

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.cardSurface)
                            .frame(width: 0.75*parentWidth, height: 0.18*parentHeight)
                            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.cardBorder, lineWidth: 4)
                            )

                        VStack(spacing: 16) {
                            Text("Add Topic")
                                .font(Font.title.bold())
                                .foregroundStyle(Color.primaryText)

                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.inputSurface)
                                .frame(width: 0.6*parentWidth, height: 35)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color.inputBorder, lineWidth: 3)
                                )
                                .overlay(
                                    TextField(
                                        "",
                                        text: $topicName,
                                        prompt: Text("Enter topic name").foregroundStyle(Color.placeholderText)
                                    )
                                    .foregroundStyle(Color.primaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 12)
                                )
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(Color.headerRed)
                            .font(.footnote)
                            .padding(.top, 8)
                    }

                    Spacer()

                    Button(action: save) {
                        Text("Save")
                            .font(Font.title2.bold())
                            .foregroundStyle(Color.primaryText)
                            .frame(width: 0.5*parentWidth, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.cardSurface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.cardBorder, lineWidth: 3)
                                    )
                            )
                    }
                    .disabled(topicName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .padding(.bottom, 0.08*parentHeight)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    /// Live-updates as the user types, so the header reflects the topic being created.
    private var headerTitle: String {
        let trimmed = topicName.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? "New Topic" : trimmed
    }

    private func save() {
        let name = topicName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        do {
            try Database.insertLanguage(name: name)
            router.pop()
        } catch {
            errorMessage = "Could not add \"\(name)\" — it may already exist."
        }
    }
}

#Preview {
    NavigationStack {
        AddLanguagePage()
            .environmentObject(Router())
    }
}
