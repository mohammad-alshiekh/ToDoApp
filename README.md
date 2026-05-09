#  ToDoAlp - Professional Task Workspace

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/GetX-8B22FF?style=for-the-badge&logo=getx&logoColor=white)](https://pub.dev/packages/get)
[![Hive](https://img.shields.io/badge/Hive-FFD700?style=for-the-badge&logo=hive&logoColor=black)](https://pub.dev/packages/hive)

**ToDoAlp** is a high-performance, professional task management application built with Flutter. It combines a sleek, modern UI with robust local data persistence and advanced productivity features to help users stay organized and focused.

---

##  Key Features

###  Advanced Task Management (CRUD)
- **Create & Organize**: Add tasks with titles, detailed descriptions, priorities, and categories.
- **Smart Editing**: Refine task details in-place with a dedicated, intuitive editing interface.
- **Quick Status**: Toggle task completion with a single tap directly from the dashboard.

###   Productivity Insights
- **Live Statistics**: Visualize your progress through an interactive dashboard.
- **Priority Breakdown**: High-level overview of task distribution across Low, Medium, and High priorities.
- **Category Analytics**: Understand where your time goes with category-based tracking.

###   Search & Filtering
- **Real-time Search**: Find any task instantly with a powerful reactive search engine.
- **Smart Filters**: Filter your workspace by Category or Priority to focus on what matters most.

###   Smart Reminders
- **Local Notifications**: Never miss a deadline with automated local notification scheduling for due tasks.
- **Configurable Alerts**: Enable or disable reminders per task.

###  Premium UI/UX
- **Dynamic Themes**: Seamlessly switch between elegant Light and Deep Dark modes.
- **Fluid Animations**: Powered by `flutter_animate` for a polished, "app-like" feel.
- **Modern Design**: Gradient headers, card-based layouts, and custom interactive widgets.

---

##  Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [GetX](https://pub.dev/packages/get) (Reactive & High-performance)
- **Local Database**: [Hive](https://pub.dev/packages/hive) (NoSQL storage for lightning-fast persistence)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate) & [animations](https://pub.dev/packages/animations)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Date/Time**: [intl](https://pub.dev/packages/intl) & [timezone](https://pub.dev/packages/timezone)

---

##   Getting Started

### Prerequisites
- Flutter SDK installed (v3.0.0+)
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohammad-alshiekh/ToDoApp.git
   cd todoalp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

##   Project Structure

```
lib/
├── controllers/    # Business logic & State management (GetX)
├── data/           # Models, Repositories, & Hive Providers
├── routes/         # App routing configuration
├── services/       # Core services (Theme, Notifications)
├── ui/             # Screens, Widgets, & Themes
└── utils/          # Bindings & Constants
```

---

 
*Developed with ❤️ by MSH*
