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
    let imageName: String
}

struct ContentView: View {
    let tasks = [
        Task(name: "Zrobić zakupy", imageName: "cart"),
        Task(name: "Wyprowadzić psa", imageName: "dog"),
        Task(name: "Skończyć projekt", imageName: "note"),
        Task(name: "Zadzwonić gdzieś", imageName: "phone")
    ]

    var body: some View {
        NavigationView {
            List(tasks) { task in
                HStack {
                    Image(systemName: task.imageName)
                    Text(task.name)
                }
            }
                    .navigationTitle("Lista zadań")
        }
    }
}

#Preview {
    ContentView()
}