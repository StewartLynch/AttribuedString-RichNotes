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

struct NotesEditorView: View {
    @Bindable var note: RichTextNote
    @State private var selection = AttributedTextSelection()
    @FocusState private var isFocused: Bool
    @State private var moreEditing = false
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Category.name) private var categories: [Category]
    @State private var selectedCategory: String = Category.uncategorized
    @State private var editCategories = false
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                if categories.isEmpty {
                    Text("No Categories")
                } else {
                    Picker("Category", selection: $selectedCategory) {
                        Text(Category.uncategorized).tag(Category.uncategorized)
                        ForEach(categories) { category in
                            Text(category.name).tag(category.name)
                        }
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: selectedCategory) {
                        if let category = categories.first(where: {$0.name == selectedCategory}) {
                            note.category = category
                        } else {
                            note.category = nil
                        }
                        try? context.save()
                    }
                    Button {
                        editCategories.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(.circle)
                    .tint(note.category != nil ? Color(hex: note.category!.hexColor)! : .accentColor)
                    .onAppear {
                        if let category = note.category {
                            selectedCategory = category.name
                        }
                    }
                    .sheet(isPresented: $editCategories, onDismiss: {
                        selectedCategory = note.category?.name ?? Category.uncategorized
                    }) {
                        CategoriesView()
                    }
                }
            }
            TextEditor(text: $note.text, selection: $selection)
                .focused($isFocused)
                .scrollBounceBehavior(.basedOnSize)
        }
        .padding()
            .navigationTitle("RichText Editor")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if note.text.characters.isEmpty {
                            context.delete(note)
                        }
                        try? context.save()
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Group {
                        FormatStyleButtons(text: $note.text, selection: $selection)
                        Spacer()
                        Button {
                            moreEditing.toggle()
                        } label: {
                            Image(systemName: "textformat.alt")
                        }
                        Button {
                            isFocused = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                    .disabled(!isFocused)
                }
            }
            .sheet(isPresented: $moreEditing) {
                MoreFormattingView(text: $note.text, selection: $selection)
                    .presentationDetents([.height(200)])
            }
            .onChange(of: note.text) {
                note.updatedOn = Date.now
            }
    }
}

#Preview(traits: .mockData) {
    @Previewable @Query var notes: [RichTextNote]
    NavigationStack {
        NotesEditorView(note: notes.first!)
    }
}
