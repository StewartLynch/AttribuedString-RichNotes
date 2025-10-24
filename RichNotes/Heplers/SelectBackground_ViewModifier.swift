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


import Foundation
import SwiftUI

struct SelectedBackground: ViewModifier {
    let state: Bool
    let isButton: Bool
    func body(content: Content) -> some View {
        if state {
            if isButton {
                content
                    .foregroundStyle(.white)
                    .background(.tint, in: .circle)
            } else {
                content
                    .foregroundStyle(.white)
                    .background(.tint, in: .rect(cornerRadius: 8))
            }
        } else {
            content
        }
    }
}

extension View {
    func selectedBackground(state: Bool, isButton: Bool = true) -> some View {
        modifier(SelectedBackground(state: state, isButton: isButton))
    }
}
