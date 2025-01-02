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
    var status: Bool
}

struct ContentView: View {
    @State private var tasks = [
        Task(name: "Zrobić zakupy", imageName: "cart", status: false),
        Task(name: "Wyprowadzić psa", imageName: "dog", status: false),
        Task(name: "Skończyć projekt", imageName: "note", status: false),
        Task(name: "Zadzwonić gdzieś", imageName: "phone", status: false),
        Task(name: "Test usuwania", imageName: "phone", status: false)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach($tasks) { $task in
                    HStack {
                        Image(systemName: task.imageName)
                        Text(task.name)
                        Spacer()
                        Button(action: {
                            task.status.toggle()
                        }) {
                            Image(systemName: task.status ? "checkmark.circle.fill" : "circle")
                        }
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