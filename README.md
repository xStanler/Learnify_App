# **Learnify App**

**Welcome in Learnify App project.**      
    It's simple app that solves my needs for learing new words / concepts. Someone may say that it looks and works similiar to Duoling, but that's not right. It generates lessons based by topic of choice. App takes chooses words/cards based on self-made validation algorithm and then checks users knowledge of current topic (Somthing like Aanki). Learnify was made for people by people (one person to be exact).

Creator: *Stanisław Chmielewski*

**Table of Contents**
- [Technology Stack](#technology-stack)
- [Project structure](#project-structure)
- [FAQ](#faq)

## Technology Stack:
```
- Platform: iOS
- UI: SwiftUI
- Database: SQLite
```

## Project structure:

```
.
├── Learnify.xcodeproj/
│   └── < xcode project files >
├── Learnify/
│   ├── Assets.cassets /
│   │   └── < xcode assets >
│   ├── AboutPage.swift         -> [about-page]
│   ├── AddLanguage.swift       -> [add-language]
│   ├── Database.swift          -> [database]
│   ├── LearnifyApp.swift       -> [app]
│   ├── MainPage.swift          -> [main-page]
│   ├── MainPageViewModel.swift -> [main-viewModel]
│   ├── rootPage.swift          -> [root-page]
│   └── variables.swift         -> [variables]
├── LearnifyTests/
│   └── < app functionality tests [ not public right now ] >
├── LearnifyUITest/
│   └── < app's UI tests [ not public right now] >
├── SQLite 2.xcodeproj/
│   └── < SQLite package for Swift >
├── SQLite.xcodeproj/
│   └── < SQLite package for Swift >
└── README.md
```

:computer: **[about-page]**: *Page with breif description of the app.*
![About Page](https://github.com/xStanler/Learnify_App/blob/readme-feature/AboutPage.png | width=100)

:computer: **[add-language]**: *Page for adding new topic.*

:computer: **[database]**: *Swift implementation of database, and tables with schemas.*

:computer: **[app]**: *Main app program. Renders program and calls app() function.*

:computer: **[main-page]**: *Main page of the app.*

:computer: **[main-viewModel]**: *Fetches db data to [main-page].*

:computer: **[root-page]**: *Implements sctructure of pages.*

:computer: **[variables]**: *File with global variables, eg. colors, functions.*

## FAQ:

>### 1. Why you're making this app?
> I'm making this app, because I want to learn new things, like Swift, SwiftUI and database integretion.

>### 2. Where idea for this app came from?
> I was searching for good anki-style app for iOS, but everyone of them where either pricey or full of ads, and I didn't like that.
