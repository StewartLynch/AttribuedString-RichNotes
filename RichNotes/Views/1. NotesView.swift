//
//----------------------------------------------
// Original project: RichNotes
// by  Stewart Lynch on 2025-10-28
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.


import SwiftUI
import SwiftData

struct NotesView: View {
    
    @Environment(\.modelContext) var context
    @State private var path = NavigationPath()

    @State private var sortByCreation = true
    @State private var filterCategory = Category.all
    @Query(sort: \Category.name) var categories: [Category]
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    VStack {
                        Picker("Sort Order", selection: $sortByCreation) {
                            Text("Creation Date").tag(true)
                            Text("Last updated").tag(false)
                        }
                        Text("Sort Order")
                    }
                    VStack {
                        Picker("Category Filter", selection: $filterCategory) {
                            Text(Category.all).tag(Category.all)
                            Text(Category.uncategorized).tag(Category.uncategorized)
                            ForEach(categories) { category in
                                Text(category.name).tag(category.name)
                            }
                        }
                        Text("Category")
                    }
                }
                .buttonStyle(.bordered)
                NotesListView(sortByCreation: sortByCreation, filterCategory: filterCategory)
            }
            .navigationTitle("Rich Notes")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(for: RichTextNote.self) { note in
                NotesEditorView(note: note)
            }
            .toolbar {
                Button {
                    let newNote = RichTextNote(text: "")
                    context.insert(newNote)
                    path.append(newNote)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview(traits: .mockData) {
    NotesView()
}
