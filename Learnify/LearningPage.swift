//
//  LearningPage.swift
//  Learnify
//

import SwiftUI

struct LearningPage: View {
    let scope: LearningScope

    @EnvironmentObject private var router: Router
    @AppStorage("lessonLength") private var lessonLength: Double = 20
    @State private var deck: [Database.WordRow] = []
    @State private var currentWord: Database.WordRow?
    @State private var answer = ""
    @State private var lastResult: Bool?
    @State private var cardsCompleted = 0
    @State private var isLessonComplete = false
    @FocusState private var isAnswerFocused: Bool

    var body: some View {
        GeometryReader { proxy in
            let parentWidth = proxy.size.width
            let parentHeight = proxy.size.height

            ZStack {
                Color.learnifyBackground
                    .ignoresSafeArea(edges: .all)

                if isLessonComplete {
                    lessonCompleteView(parentWidth: parentWidth, parentHeight: parentHeight)
                } else if let lastResult {
                    ResultPage(isCorrect: lastResult, onContinue: advance)
                } else {
                    VStack {
                        HeaderBanner(accentColor: lessonAccentColor, width: parentWidth, height: 0.2 * parentHeight) {
                            router.popToRoot()
                        }
                        .frame(width: parentWidth, height: 0.2 * parentHeight)

                        Spacer()

                        if let currentWord {
                            cardView(currentWord, parentWidth: parentWidth, parentHeight: parentHeight)
                        } else {
                            Text(emptyMessage)
                                .foregroundStyle(Color.primaryText)
                        }

                        Spacer()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: startSession)
    }

    private var emptyMessage: String {
        switch scope {
        case .language(_, let name):
            return "No cards yet for \(name)."
        case .mega:
            return "No cards yet — add some first."
        }
    }

    /// Each language always maps to the same palette color, so its lesson
    /// header looks the same every time you return to it.
    private var lessonAccentColor: Color {
        switch scope {
        case .language(let id, _):
            let index = Int(abs(id)) % Color.lessonPalette.count
            return Color.lessonPalette[index]
        case .mega:
            return .megaLessonAccent
        }
    }

    @ViewBuilder
    private func cardView(_ card: Database.WordRow, parentWidth: CGFloat, parentHeight: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.cardSurface)
            .frame(width: 0.75*parentWidth, height: 0.4*parentHeight)
            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 4)
            )
            .overlay(
                VStack(spacing: 16) {
                    if let imageName = card.helpImage, let uiImage = ImageStore.loadImage(imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 0.65*parentWidth, height: 0.16*parentHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }

                    Text(card.word)
                        .font(.system(size: 25))
                        .foregroundStyle(Color.promptText)

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
                                text: $answer,
                                prompt: Text("Enter translation here").foregroundStyle(Color.placeholderText)
                            )
                            .foregroundStyle(Color.primaryText)
                            .multilineTextAlignment(.center)
                            .focused($isAnswerFocused)
                            .submitLabel(.done)
                            .onSubmit(submit)
                            .padding(.horizontal, 12)
                        )
                }
                .padding(20)
            )
    }

    private func startSession() {
        cardsCompleted = 0
        isLessonComplete = false
        loadDeck()
    }

    private func loadDeck() {
        do {
            switch scope {
            case .language(let id, _):
                deck = try Database.fetchWords(languageId: id)
            case .mega:
                deck = try Database.fetchAllWords()
            }
            pickNext()
        } catch {
            deck = []
            currentWord = nil
        }
    }

    /// Weaker cards (lower proficiency_level) are weighted to come up more often.
    private func pickNext() {
        answer = ""
        guard !deck.isEmpty else {
            currentWord = nil
            return
        }

        let weights = deck.map { 1.0 / Double($0.proficiencyLevel + 1) }
        let totalWeight = weights.reduce(0, +)
        var target = Double.random(in: 0..<totalWeight)
        for (index, weight) in weights.enumerated() {
            if target < weight {
                currentWord = deck[index]
                return
            }
            target -= weight
        }
        currentWord = deck.last
    }

    private func submit() {
        guard let currentWord else { return }
        let correct = translationMatches(answer, currentWord.translation)
        try? Database.updateProficiency(id: currentWord.id, delta: correct ? 1 : -1)
        lastResult = correct
    }

    private func advance() {
        lastResult = nil
        cardsCompleted += 1
        let sessionTarget = deck.isEmpty ? 0 : min(Int(lessonLength), deck.count)
        if cardsCompleted >= sessionTarget {
            isLessonComplete = true
        } else {
            loadDeck()
        }
    }

    @ViewBuilder
    private func lessonCompleteView(parentWidth: CGFloat, parentHeight: CGFloat) -> some View {
        VStack {
            HeaderBanner(accentColor: lessonAccentColor, width: parentWidth, height: 0.2 * parentHeight) {
                router.popToRoot()
            }
            .frame(width: parentWidth, height: 0.2 * parentHeight)

            Spacer()

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardSurface)
                .frame(width: 0.75*parentWidth, height: 0.35*parentHeight)
                .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0.01*parentHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.cardBorder, lineWidth: 4)
                )
                .overlay(
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(lessonAccentColor)
                        Text("Lesson Complete!")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(Color.primaryText)
                        Text("\(cardsCompleted) card\(cardsCompleted == 1 ? "" : "s") reviewed")
                            .font(.footnote)
                            .foregroundStyle(Color.promptText)
                    }
                )

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            router.popToRoot()
        }
    }
}

#Preview {
    NavigationStack {
        LearningPage(scope: .language(id: 1, name: "French"))
            .environmentObject(Router())
    }
}
