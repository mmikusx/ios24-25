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
    @State private var tasks = [
        Task(name: "Zrobić zakupy", imageName: "cart"),
        Task(name: "Wyprowadzić psa", imageName: "dog"),
        Task(name: "Skończyć projekt", imageName: "note"),
        Task(name: "Zadzwonić gdzieś", imageName: "phone"),
        Task(name: "Test to delete", imageName: "phone")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Image(systemName: task.imageName)
                        Text(task.name)
                    }
                }
                        .onDelete(perform: deleteTask)
            }
                    .navigationTitle("Lista zadań")
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}