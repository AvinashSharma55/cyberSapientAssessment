//
//  ContentView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TaskViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        NavigationStack {
            TaskListView(viewModel: viewModel)
                .environment(\.managedObjectContext, viewContext)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .tint(viewModel.accentColor)
    }
}

#Preview {
    ContentView(viewContext: PersistenceController.preview.container.viewContext)
}
