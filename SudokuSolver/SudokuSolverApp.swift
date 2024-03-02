//
//  SudokuSolverApp.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI

@main
struct SudokuSolverApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
