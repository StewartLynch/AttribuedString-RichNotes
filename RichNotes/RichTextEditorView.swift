//
//----------------------------------------------
// Original project: RichNotes
// by  Stewart Lynch on 2025-10-22
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

struct RichTextEditorView: View {
    @State private var text: AttributedString = ""
    @State private var selection = AttributedTextSelection()
    @State private var moreEditing = false
    @FocusState private var isFocused: Bool
    var body: some View {
        NavigationStack {
            TextEditor(text: $text, selection: $selection)
                .focused($isFocused)
                .padding()
                .scrollBounceBehavior(.basedOnSize)
                .navigationTitle("RichText Editor")
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Group {
                            FormatStyleButtons(text: $text, selection: $selection)
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
                    MoreFormattingView(text: $text, selection: $selection)
                        .presentationDetents([.height(200)])
                }
        }
    }
}

#Preview {
    RichTextEditorView()
}
