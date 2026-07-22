//
//  AddCardPage.swift
//  Learnify
//

import SwiftUI
import PhotosUI
import UIKit

struct AddCardPage: View {
    let languageId: Int64
    let languageName: String

    @EnvironmentObject private var router: Router
    @State private var word = ""
    @State private var translation = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var errorMessage: String?

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack {
                    HeaderBanner(accentColor: .headerRose, title: languageName, width: parentWidth, height: 0.2 * parentHeight) {
                        router.popToRoot()
                    }
                    .frame(width: parentWidth, height: 0.2 * parentHeight)

                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Add Card")
                                .font(Font.title.bold())
                                .foregroundStyle(Color.primaryText)
                                .padding(.top, 20)

                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                imageTile(parentWidth: parentWidth)
                            }
                            .onChange(of: selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }

                            inputField(placeholder: "Enter word here", text: $word, parentWidth: parentWidth)
                            inputField(placeholder: "Enter translation here", text: $translation, parentWidth: parentWidth)

                            if let errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(Color.headerRed)
                            }

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
                            .disabled(
                                word.trimmingCharacters(in: .whitespaces).isEmpty
                                || translation.trimmingCharacters(in: .whitespaces).isEmpty
                            )
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private func imageTile(parentWidth: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.inputSurface)
            .frame(width: 0.65*parentWidth, height: 160)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.inputBorder, lineWidth: 3)
            )
            .overlay {
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 0.65*parentWidth, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                } else {
                    Text("+")
                        .font(Font.largeTitle.bold())
                        .foregroundStyle(Color.headerRose)
                }
            }
    }

    @ViewBuilder
    private func inputField(placeholder: String, text: Binding<String>, parentWidth: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.inputSurface)
            .frame(width: 0.65*parentWidth, height: 35)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.inputBorder, lineWidth: 3)
            )
            .overlay(
                TextField("", text: text, prompt: Text(placeholder).foregroundStyle(Color.placeholderText))
                    .foregroundStyle(Color.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            )
    }

    private func save() {
        let wordTrimmed = word.trimmingCharacters(in: .whitespaces)
        let translationTrimmed = translation.trimmingCharacters(in: .whitespaces)
        guard !wordTrimmed.isEmpty, !translationTrimmed.isEmpty else { return }

        do {
            var imageFilename: String?
            if let selectedImageData {
                imageFilename = try ImageStore.save(selectedImageData)
            }
            try Database.insertWord(
                word: wordTrimmed,
                translation: translationTrimmed,
                helpImage: imageFilename,
                languageId: languageId
            )
            router.pop()
        } catch {
            errorMessage = "Could not save this card — the word may already exist for \(languageName)."
        }
    }
}

#Preview {
    NavigationStack {
        AddCardPage(languageId: 1, languageName: "French")
            .environmentObject(Router())
    }
}
