# Screenshot AI

**Screenshot AI** is a lightweight macOS menu bar application that allows you to capture a portion of the screen, extract text using OCR, and ask AI questions about the captured content.

The app integrates macOS screenshot tools, Apple's Vision OCR framework, and AI models (OpenAI or Gemini) to provide instant contextual analysis of screenshots.

---

# Features

* 📸 **Interactive Screenshot Capture**

  * Select any area of your screen using the native macOS screenshot tool.

* 🔎 **OCR Text Extraction**

  * Uses Apple's **Vision framework** to detect and extract text from screenshots.

* 🤖 **AI-powered Analysis**

  * Ask questions about the extracted text.
  * Supports:

    * OpenAI models
    * Google Gemini models

* ⌨ **Global Keyboard Shortcut**

  * Trigger screenshot capture from anywhere.

* 🧠 **Context-aware Queries**

  * The AI receives the extracted text as context for answering questions.

* 🧾 **Menu Bar Application**

  * Runs as a macOS menu bar utility.
  * No Dock icon.

* 📋 **Copy AI Responses**

  * Easily copy generated responses to the clipboard.

---

# Demo Workflow

1. Press the global shortcut:

```
Cmd + Shift + X
```

2. Select an area of the screen.

3. The app will:

```
Screenshot → OCR → Open Query Window
```

4. Ask questions about the screenshot:

Example:

```
"What error is shown in this screenshot?"
"Explain the code shown here"
"Summarize this text"
```

---

# Architecture

The project follows a **clean SwiftUI + MVVM architecture**.

```
ScreenShotAI
│
├── Models
│   ├── AppState.swift
│   └── ScreenshotError.swift
│
├── Services
│   ├── ScreenshotManager.swift
│   ├── OCRService.swift
│   └── AIService.swift
│
├── ViewModels
│   └── QueryViewModel.swift
│
├── Views
│   ├── MenuBarView.swift
│   ├── QueryWindow.swift
│   └── SettingsView.swift
│
├── Utilities
│   ├── Config.swift
│   ├── KeyboardShortcuts+Extension.swift
│   └── WindowAccessor.swift
```

### Core Components

#### ScreenshotManager

Handles screenshot capture using the macOS `screencapture` CLI.

#### OCRService

Uses the **Vision framework** to extract text from images.

#### AIService

Handles AI queries using:

* OpenAI API
* Google Gemini API (OpenAI-compatible endpoint)

#### AppState

Central application state responsible for:

```
Screenshot → OCR → Window display
```

---

# Technologies Used

* **Swift 5**
* **SwiftUI**
* **Vision Framework (OCR)**
* **macOS screencapture CLI**
* **OpenAI API**
* **Google Gemini API**
* **KeyboardShortcuts Swift Package**

Dependencies:

```
https://github.com/MacPaw/OpenAI
https://github.com/sindresorhus/KeyboardShortcuts
```

---

# Requirements

* macOS **14+**
* Xcode **16+**

---

# Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/ScreenshotAI.git
cd ScreenshotAI
```

### 2. Open the project

```
ScreenShotAI.xcodeproj
```

### 3. Configure API Keys

Edit:

```
Utilities/Config.swift
```

Insert your API key:

```swift
static let openAIKey = "YOUR_OPENAI_API_KEY"
```

or for Gemini:

```swift
static let useGemini = true
static let geminiKey = "YOUR_GEMINI_API_KEY"
```

⚠️ Do **not commit API keys** in production projects.

---

# Usage

Run the app from Xcode.

Once running:

1️⃣ The app appears in the **menu bar**.

2️⃣ Trigger screenshot capture:

```
Cmd + Shift + X
```

3️⃣ Select a screen region.

4️⃣ Ask questions about the extracted text.

---

# Settings

The settings window allows customization of the global shortcut.

Accessible from the menu bar:

```
Menu → Settings
```

---

# Security Notes

Currently API keys are stored in:

```
Config.swift
```

For production applications consider using:

* macOS **Keychain**
* Environment variables
* Secure configuration files

---

# Future Improvements

Possible enhancements:

* Drag-and-drop image support
* Screenshot history
* AI streaming responses
* Better OCR formatting
* Local LLM support
* Markdown rendering
* Image understanding (Vision models)

---

# License

MIT License

---

# Author

Anrkuist

---
