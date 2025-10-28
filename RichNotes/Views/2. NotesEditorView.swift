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
    var body: some View {
        TextEditor(text: $note.text, selection: $selection)
            .focused($isFocused)
            .padding()
            .scrollBounceBehavior(.basedOnSize)
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
