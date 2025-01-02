//
//  ContentView.swift
//  TaskList
//
//  Created by Mikołaj Szymański on 02/01/2025.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let name: String
}

struct ContentView: View {
    let tasks = [
        Task(name: "Zrobić zakupy"),
        Task(name: "Wyprowadzić psa"),
        Task(name: "Skończyć projekt"),
        Task(name: "Zadzwonić gdzieś")
    ]

    var body: some View {
        NavigationView {
            List(tasks) { task in
                Text(task.name)
            }
                    .navigationTitle("Lista zadań")
        }
    }
}

#Preview {
    ContentView()
}