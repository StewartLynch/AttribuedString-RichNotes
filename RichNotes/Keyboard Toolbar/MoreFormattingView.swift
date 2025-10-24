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

struct MoreFormattingView: View {
    @Environment(\.fontResolutionContext) var fontResolutionContext
    @Binding var text: AttributedString
    @Binding var selection: AttributedTextSelection
    @State private var color = Color.primary
    var body: some View {
        var selCopy = selection
        let states = SelectionState.selectionStyleState(
            text: text,
            selection: &selCopy) { font in
                let resolved = font.resolve(in: fontResolutionContext)
                return (resolved.isBold, resolved.isItalic)
            }
        VStack(alignment: .leading) {
            Text("Format").bold()
            ScrollView(.horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Button("Extra Large") {
                        text.transformAttributes(in: &selection) { container in
                            container.font = .title
                        }
                    }.font(.title).padding(.horizontal, 5)
                        .selectedBackground(state: SelectionState.isSelected(for: states.extraLargeFont), isButton: false)
                    Button("Large") {
                        text.transformAttributes(in: &selection) { container in
                            container.font = .title2
                        }
                    }.font(.title2).padding(.horizontal, 5)
                        .selectedBackground(state: SelectionState.isSelected(for: states.largeFont), isButton: false)
                    Button("Medium") {
                        text.transformAttributes(in: &selection) { container in
                            container.font = .title3
                        }
                    }.font(.title3).padding(.horizontal, 5)
                        .selectedBackground(state: SelectionState.isSelected(for: states.mediumFont), isButton: false)
                    Button("Body") {
                        text.transformAttributes(in: &selection) { container in
                            container.font = .body
                        }
                    }.font(.body).padding(.horizontal, 5)
                        .selectedBackground(state: SelectionState.isSelected(for: states.bodyFont), isButton: false)
                    Button("Footnote") {
                        text.transformAttributes(in: &selection) { container in
                            container.font = .footnote
                        }
                    }.font(.footnote).padding(.horizontal, 5)
                        .selectedBackground(state: SelectionState.isSelected(for: states.footnoteFont), isButton: false)
                }
                ScrollView(.horizontal) {
                    HStack {
                        FormatStyleButtons(text: $text, selection: $selection)
                        Button {
                            text.transformAttributes(in: &selection) { container in
                                container.alignment = .left
                            }
                        } label: {
                            Image(systemName: "text.alignleft")
                        }
                        .frame(width: 40, height: 40)
                        .selectedBackground(state: SelectionState.isSelected(for: states.leftAlignment))
                        Button {
                            text.transformAttributes(in: &selection) { container in
                                container.alignment = .center
                            }
                        } label: {
                            Image(systemName: "text.aligncenter")
                        }
                        .frame(width: 40, height: 40)
                        .selectedBackground(state: SelectionState.isSelected(for: states.centerAlignment))
                        Button {
                            text.transformAttributes(in: &selection) { container in
                                container.alignment = .right
                            }
                        } label: {
                            Image(systemName: "text.alignright")
                        }
                        .frame(width: 40, height: 40)
                        .selectedBackground(state: SelectionState.isSelected(for: states.rightAlignment))
                        ColorPicker("Text Color", selection: $color)
                            .labelsHidden()
                            .frame(width: 40, height: 40)
                            .onChange(of: color) {
                                text.transformAttributes(in: &selection) { container in
                                    container.foregroundColor = color
                                }
                            }
                    }
                    .font(.system(size: 22))
                }
            }
            Button("Remove Formatting") {
                text.transformAttributes(in: &selection) { container in
                    container = AttributeContainer()
                }
            }
            .buttonStyle(.bordered)
        }
        .buttonStyle(.plain)
        .padding()
    }
}

#Preview {
    MoreFormattingView(text: .constant(""), selection: .constant(AttributedTextSelection()))
        .frame(height: 200)
}
