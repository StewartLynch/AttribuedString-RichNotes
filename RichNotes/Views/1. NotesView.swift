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
    @Query private var notes: [RichTextNote]
    @Environment(\.modelContext) var context
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !notes.isEmpty {
                    List {
                        ForEach(notes) { note in
                            NavigationLink (value: note ){
                                VStack(alignment: .leading) {
                                    Text(note.text)
                                    Text("Updated: \(Text(note.updatedOn, style: .date)) \(Text(note.updatedOn, style: .time))")
                                    if let category = note.category {
                                        Text(category.name)
                                            .foregroundStyle(Color(hex: category.hexColor)!)
                                    }
                                }
                            }
                        }
                        .onDelete { indices in
                            for index in indices {
                                context.delete(notes[index])
                            }
                            try? context.save()
                        }
                    }
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView("Create your first note", systemImage: "square.and.pencil")
                }
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
