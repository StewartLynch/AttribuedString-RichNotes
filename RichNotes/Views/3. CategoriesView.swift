//
//----------------------------------------------
// Original project: RichNotes
// by  Stewart Lynch on 2025-10-29
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

struct CategoriesView: View {
    enum Action: String {
        case new = "New Category"
        case edit = "Edit Category"
        case none = "Categories"
    }
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query(sort: \Category.name) private var categories: [Category]
    @State private var action = Action.none
    @State private var newCategory = false
    @State private var categoryName = ""
    @State private var hexColor = Color.primary
    @State private var selectedCategory: Category?
    var body: some View {
        NavigationStack {
            VStack {
                if action != .none {
                    HStack {
                        TextField("Category Name", text: $categoryName)
                            .textFieldStyle(.roundedBorder)
                        ColorPicker("Color", selection: $hexColor, supportsOpacity: false)
                            .labelsHidden()
                        if !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Button {
                                if let selectedCategory,
                                   let foundCategory = categories.first(where: {$0.id == selectedCategory.id}) {
                                    foundCategory.name = categoryName
                                    foundCategory.hexColor = hexColor.toHex()!
                                } else {
                                    let newCategory = Category(name: categoryName, hexColor: hexColor.toHex()!)
                                    context.insert(newCategory)
                                }
                                try? context.save()
                                withAnimation {
                                    reset()
                                }
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.glassProminent)
                        }
                    }
                }
                if categories.isEmpty {
                    ContentUnavailableView("Create your first category", systemImage: "pencil.and.scribble")
                } else {
                    List {
                        ForEach(categories) { category in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(Color(hex: category.hexColor)!)
                                Text(category.name)
                                if action != .new {
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            action = .edit
                                            selectedCategory = category
                                            categoryName = category.name
                                            hexColor = Color(hex: category.hexColor)!
                                        }
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                }
                            }
                        }
                        .onDelete { indices in
                            for index in indices {
                                context.delete(categories[index])
                            }
                            try? context.save()
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle(action.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        action = .new
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func reset() {
        action = .none
        categoryName = ""
        hexColor = .primary
        selectedCategory = nil
    }
}

#Preview(traits: .mockData) {
    CategoriesView()
}
