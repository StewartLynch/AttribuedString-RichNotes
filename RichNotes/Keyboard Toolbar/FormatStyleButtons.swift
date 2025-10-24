//
//----------------------------------------------
// Original project: RichNotes
// by  Stewart Lynch on 2025-10-24
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

struct FormatStyleButtons: View {
    @Environment(\.fontResolutionContext) var fontResolutionContext
    @Binding var text: AttributedString
    @Binding var selection: AttributedTextSelection
    var body: some View {
        var selCopy = selection
        let states = SelectionState.selectionStyleState(
            text: text,
            selection: &selCopy) { font in
                let resolved = font.resolve(in: fontResolutionContext)
                return (resolved.isBold, resolved.isItalic)
            }
        Button {
            text.transformAttributes(in: &selection) { container in
                let currentFont = container.font ?? .default
                let resolved = currentFont.resolve(in: fontResolutionContext)
                container.font = currentFont.bold(!resolved.isBold)
            }
        } label: {
            Image(systemName: "bold")
        }
        .frame(width: 40, height: 40)
        .selectedBackground(state: SelectionState.isSelected(for: states.bold))
        Button {
            text.transformAttributes(in: &selection) { container in
                let currentFont = container.font ?? .default
                let resolved = currentFont.resolve(in: fontResolutionContext)
                container.font = currentFont.italic(!resolved.isItalic)
            }
        } label: {
            Image(systemName: "italic")
        }
        .frame(width: 40, height: 40)
        .selectedBackground(state: SelectionState.isSelected(for: states.italic))
        Button {
            text.transformAttributes(in: &selection) { container in
                if container.underlineStyle == .single {
                    container.underlineStyle = .none
                } else {
                    container.underlineStyle = .single
                }
            }
        } label: {
            Image(systemName: "underline")
        }
        .frame(width: 40, height: 40)
        .selectedBackground(state: SelectionState.isSelected(for: states.underline))
        Button {
            text.transformAttributes(in: &selection) { container in
                if container.strikethroughStyle == .single {
                    container.strikethroughStyle = .none
                } else {
                    container.strikethroughStyle = .single
                }
            }
        } label: {
            Image(systemName: "strikethrough")
        }
        .frame(width: 40, height: 40)
        .selectedBackground(state: SelectionState.isSelected(for: states.strikethrough))
    }
}

#Preview {
    FormatStyleButtons(text: .constant(""), selection:  .constant(AttributedTextSelection()))
}
