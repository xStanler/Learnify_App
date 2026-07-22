//
//  EditLanguagePage.swift
//  Learnify
//

import SwiftUI
import UniformTypeIdentifiers

struct EditLanguagePage: View {
    let languageId: Int64
    let languageName: String

    @EnvironmentObject private var router: Router
    @State private var words: [Database.WordRow] = []
    @State private var errorMessage: String?
    @State private var isImporting = false
    @State private var importSummary: String?

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                VStack(spacing: 0) {
                    HeaderBanner(accentColor: .headerRose, title: languageName, width: parentWidth, height: 0.2 * parentHeight) {
                        router.popToRoot()
                    }
                    .frame(width: parentWidth, height: 0.2 * parentHeight)
                    .padding(.bottom, 20)

                    List {
                        ForEach(words) { row in
                            wordRow(row)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)

                        addCardTile()
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        importButton()
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(Color.headerRed)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }

                        if let importSummary {
                            Text(importSummary)
                                .font(.footnote)
                                .foregroundStyle(Color.promptText)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: load)
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText, UTType(filenameExtension: "md") ?? .plainText]
        ) { result in
            handleImport(result)
        }
    }

    @ViewBuilder
    private func wordRow(_ row: Database.WordRow) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.inputSurface)
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.inputBorder, lineWidth: 3)
                    .overlay(
                        Text(row.word)
                            .font(.system(size: 24))
                            .foregroundStyle(Color.primaryText)
                    )
            )
    }

    @ViewBuilder
    private func addCardTile() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.inputSurface)
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.inputBorder, lineWidth: 3)
                    .overlay(
                        Text("+")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.headerRose)
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                router.push(.addCard(languageId: languageId, languageName: languageName))
            }
    }

    @ViewBuilder
    private func importButton() -> some View {
        Button {
            isImporting = true
        } label: {
            Text("Import from file")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.cardBorder, lineWidth: 2)
                )
        }
    }

    private func load() {
        do {
            words = try Database.fetchWords(languageId: languageId)
        } catch {
            errorMessage = "Failed to load cards: \(error)"
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let row = words[index]
            try? Database.deleteWord(id: row.id)
            if let image = row.helpImage {
                ImageStore.delete(image)
            }
        }
        load()
    }

    private func handleImport(_ result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            importSummary = "Import failed: \(error.localizedDescription)"
        case .success(let url):
            let accessed = url.startAccessingSecurityScopedResource()
            defer { if accessed { url.stopAccessingSecurityScopedResource() } }

            guard let text = try? String(contentsOf: url, encoding: .utf8) else {
                importSummary = "Could not read file."
                return
            }

            let parsed = CardImport.parse(text)
            var inserted = 0
            for card in parsed.cards {
                if (try? Database.insertWord(word: card.word, translation: card.translation, languageId: languageId)) != nil {
                    inserted += 1
                }
            }

            importSummary = "Imported \(inserted) card(s)"
                + (parsed.skippedLines > 0 ? ", skipped \(parsed.skippedLines) invalid line(s)." : ".")
            load()
        }
    }
}

#Preview {
    NavigationStack {
        EditLanguagePage(languageId: 1, languageName: "French")
            .environmentObject(Router())
    }
}
