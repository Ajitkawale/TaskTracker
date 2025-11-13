🧩 TaskTracker (macOS SwiftUI App)

🎥 Tip: For the best understanding, please review the demo video before exploring the code or running the project.

⸻

📝 Overview

TaskTracker is a clean and minimal task management app built using SwiftUI and MVVM architecture.
It allows users to add, edit, delete, and track their daily tasks with a live deadline countdown, visual progress charts, and smooth macOS-native animations.

This project was developed by Ajit Kawale, an iOS developer with hands-on experience in Swift and SwiftUI.
While I have prior experience in iOS app development, this project represents my first exploration into building a macOS SwiftUI application.
I also used AI-assisted development tools (like ChatGPT) to speed up design exploration, clarify SwiftUI architecture concepts, and ensure cleaner code quality.

⸻

🚀 Features
    •    ✅ Add, edit, and delete tasks
    •    🕓 Track deadlines with live time remaining
    •    🟢 Visual chart showing task distribution (Yet to Start / In Progress / Completed)
    •    💾 Offline persistence using UserDefaults + JSONEncoder/Decoder
    •    💻 macOS-ready adaptive SwiftUI layout
    •    ⚡ Smooth animations for insertion, deletion, and hover effects
    •    🎨 Clean, Apple-style UI and typography

⸻
                                    
🚀 How to Run
    1.    Open the project in Xcode 16.
    2.    Select My Mac as the run destination.
    3.    Press Cmd + R to build and run.
    4.    Add a few tasks to see the chart and live countdown in action.
⸻

🧭 App Flow
    1.    Sidebar (Left Panel)
Displays all tasks in a list with a task status chart on top.
Each task row shows title, due date, and progress state.
    2.    Detail Panel (Right Side)
When a task is selected, detailed information appears:
    •    Title
    •    Due date and time
    •    Description, remarks, and quick notes
    •    Edit and delete options
    3.    Add Task Sheet
Opens from the toolbar.
Lets the user input a new task title, due date/time, and description.
    4.    Edit Mode with Unsaved Changes Alert
Users can modify existing tasks.
If they switch tasks without saving, an alert appears asking to save or discard changes.
    5.    Data Persistence
All tasks are saved locally via UserDefaults, so the app runs completely offline.

⸻

🌱 Future Potential

The TaskTracker app is designed as a modular foundation that can easily grow into a more advanced productivity tool.
Here are potential next steps for future versions:
    •    ☁️ CloudKit / iCloud Sync — to automatically sync tasks across Mac, iPhone, and iPad.
    •    🔔 Local Notifications — to alert users before task deadlines.
    •    📱 Cross-Platform Build — adapt the same codebase for iOS/iPadOS using SwiftUI’s multi-platform support.
    •    🗂 Task Categories / Tags — allow users to group or color-code their tasks.
    •    🪄 AI Suggestions — automatically prioritize tasks based on due dates and frequency.
    •    🧠 Widgets & Quick Actions — view daily tasks or add new ones from the menu bar or widget area.

⸻

💡 Developer Notes

This project demonstrates:
    •    Strong understanding of SwiftUI state management (@StateObject, @Binding, @ObservedObject)
    •    Clean MVVM separation between UI and business logic
    •    Real-time updates handled efficiently using Combine
    •    Practical application of macOS design conventions, including hover effects, material backgrounds, and adaptive sidebar layouts
    •    Emphasis on code readability, reusability, and maintainable architecture

It serves as a solid showcase of SwiftUI proficiency, macOS development fundamentals, and modern app design principles.

⸻

👨‍💻 Developer Information

Developed by: Ajit Kawale
Role: iOS Developer (Swift / SwiftUI)
About Me: Passionate about building intuitive and visually appealing SwiftUI apps. This project marks my first full-featured macOS SwiftUI application, leveraging my iOS experience to explore cross-platform app design and architecture.
Assistance: I used AI tools like ChatGPT to refine structure, debug complex SwiftUI behaviors, and accelerate learning—while ensuring all implementation decisions and architecture logic were my own.

⸻

📄 License

This project is free to explore and modify for learning purposes.
© 2025 Ajit Kawale. All rights reserved.
