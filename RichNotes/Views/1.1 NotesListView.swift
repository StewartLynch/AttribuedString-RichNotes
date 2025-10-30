//
//----------------------------------------------
// Original project: RichNotes
// by  Stewart Lynch on 2025-10-30
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

struct NotesListView: View {
    @Query private var notes: [RichTextNote]
    @State private var numLines = 1.0
    @Environment(\.modelContext) var context
    init(sortByCreation: Bool, filterCategory: String) {
        let sortDescriptors: [SortDescriptor<RichTextNote>] = if sortByCreation {
            [SortDescriptor(\RichTextNote.createdOn, order: .reverse)]
        } else {
            [SortDescriptor(\RichTextNote.updatedOn, order: .reverse)]
        }
        switch filterCategory {
        case Category.all:
            _notes = Query(sort: sortDescriptors)
        case Category.uncategorized:
            let predicate = #Predicate<RichTextNote> { note in
                note.category == nil
            }
            _notes = Query(filter:predicate, sort: sortDescriptors)
        default:
            let predicate = #Predicate<RichTextNote> { note in
                note.category?.name.contains(filterCategory) == true
            }
            _notes = Query(filter:predicate, sort: sortDescriptors)
        }
    }
    var body: some View {
        if !notes.isEmpty {
            VStack {
                List {
                    ForEach(notes) { note in
                        NavigationLink (value: note ){
                            VStack(alignment: .leading) {
                                HStack {
                                    if let category = note.category {
                                        Circle()
                                            .fill(Color(hex: category.hexColor)!)
                                            .frame(width: 15)
                                    } else {
                                        Circle()
                                            .fill(.background)
                                            .frame(width: 15)
                                    }
                                    Text(note.category?.name ?? Category.uncategorized)
                                }
                                Text(note.text)
                                    .lineLimit(Int(numLines))
                                VStack(alignment: .trailing){
                                    Text(note.createdOn, style: .date)
                                    Text("Updated: \(Text(note.updatedOn, style: .date)) \(Text(note.updatedOn, style: .time))")
                                }
                                .font(.caption.italic())
                                .frame(maxWidth: .infinity, alignment: .trailing)
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
                VStack {
                    Slider(value: $numLines, in: 1...10)
                    Text("Displaying ^[\(Int(numLines)) lines](inflect: true)")
                }
                .padding()
            }
        } else {
            ContentUnavailableView("Create your first note", systemImage: "square.and.pencil")
        }
    }
}

#Preview(traits: .mockData) {
    NotesListView(sortByCreation: true, filterCategory: Category.all)
}
