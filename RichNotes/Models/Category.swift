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


import Foundation
import SwiftData

@Model
class Category {
    @Attribute(.unique)
    var name: String
    var hexColor: String
    
    @Relationship( deleteRule: .nullify)
    var notes: [RichTextNote] = []
    
    init(name: String, hexColor: String) {
        self.name = name
        self.hexColor = hexColor
    }
    
    static var all = "All Categories"
    static var uncategorized = "Uncategorized"
}
