//
//  CyberSapientAssesmentApp.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

@main
struct CyberSapientAssesmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
