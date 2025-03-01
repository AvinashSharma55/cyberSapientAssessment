# Task Manager - iOS

An interactive task manager iOS application built with SwiftUI, showcasing advanced UI/UX skills, smooth animations, intuitive navigation, and accessibility support.

## Features

### Core Features
- **Task Creation**: Add tasks with title, description, priority, and due date
- **Task List**: Dynamic, filterable list with sorting options (priority, due date, alphabetical)
- **Task Filtering**: Filter tasks by status (All, Completed, Pending)
- **Task Details**: Detailed view for each task with options to mark as completed or delete
- **Persistent Storage**: Core Data for local data persistence

### UI/UX Design
- **Modern SwiftUI Components**: NavigationStack, List, dynamic menus
- **Responsive Layout**: Optimized for iPhone and iPad
- **Theming**: Support for light and dark modes with customizable accent colors
- **Animations**: Fade-and-scale effects, spring animations, pulse effects

### Advanced UI Features
- **Drag-and-Drop**: Reorder tasks with haptic feedback
- **Swipe Gestures**: Swipe-to-delete and swipe-to-complete actions
- **Custom Progress Indicator**: Animated circular progress ring showing completion percentage
- **Empty State**: Engaging empty state UI with animation and motivational message

### Accessibility
- **VoiceOver Support**: Proper accessibility labels and hints
- **Dynamic Type**: Text scaling support
- **High Contrast**: Compatible with high-contrast mode
- **Keyboard Navigation**: Support for keyboard interaction

## Project Structure

```
CyberSapientAssesment/
├── Model/
│   ├── TaskItem+CoreDataClass.swift
│   ├── TaskItem+CoreDataProperties.swift
│   └── TaskPriority.swift
├── Views/
│   ├── CircularProgressView.swift
│   ├── EmptyStateView.swift
│   ├── SettingsView.swift
│   ├── TaskDetailView.swift
│   ├── TaskFormView.swift
│   ├── TaskListView.swift
│   ├── TaskRowView.swift
│   └── ToastView.swift
├── ViewModels/
│   └── TaskViewModel.swift
├── Extensions/
│   └── View+Extensions.swift
├── Utilities/
├── CyberSapientAssesment.xcdatamodeld/
├── Persistence.swift
├── ContentView.swift
└── CyberSapientAssesmentApp.swift
```

## Setup Instructions

1. Clone the repository
2. Open `CyberSapientAssesment.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the application (⌘+R)

## Design Rationale

### Architecture
The project follows the MVVM (Model-View-ViewModel) architecture pattern:
- **Model**: Core Data entities (TaskItem)
- **View**: SwiftUI views for UI representation
- **ViewModel**: TaskViewModel for business logic and data operations

This separation of concerns makes the code more maintainable, testable, and scalable.

### UI/UX Decisions
- **Circular Progress Indicator**: Provides visual feedback on task completion progress
- **Swipe Actions**: Intuitive gestures for common actions (complete/delete)
- **Toast Notifications**: Non-intrusive feedback with undo functionality
- **Animated Transitions**: Smooth animations for better user experience
- **Empty State**: Engaging visuals and guidance when no tasks exist

### Accessibility Considerations
- All UI elements have appropriate accessibility labels and hints
- Support for VoiceOver navigation
- Dynamic Type for text scaling
- High contrast compatibility

### Performance Optimizations
- Efficient use of `@StateObject` and `@FetchRequest` to minimize redraws
- LazyVStack for smooth scrolling with large task lists
- Shimmer loading effect during initial data load

## Testing

The project includes UI tests to verify:
- Task creation flow
- Sorting and filtering functionality
- Task completion and deletion
- Task detail view and editing
- Settings functionality

## Future Improvements

- Add categories/tags for tasks
- Add notifications/reminders
- Cloud synchronization
- More detailed statistics and insights
- Enhanced search capabilities
- Additional themes and customization options
- Remove warnings for non-compatible functions
- Improve Test Cases, As not all are passing.

## Requirements

- iOS 17.5+
- Swift 5.10
- Xcode 15+
