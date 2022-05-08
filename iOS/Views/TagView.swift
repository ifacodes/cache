//
//  TagView.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-29.
//

import SwiftUI

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = nextValue()
  }
}

struct TagModel: Identifiable, Hashable {
    var id = UUID()
    var text: String
    var width: CGFloat = 0
    var color: Color
    
    init(_ tag: Tag) {
        self.text = tag.name
        self.width = (tag.name as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]).width + 20
        self.color = Color(tag.color)
    }
}

struct TagBadge: View {
    
    var text: String
    var color: Color
    
    init(_ tag: TagModel) {
        self.text = tag.text
        self.color = tag.color
    }
    
    var body: some View {
        Text(verbatim: text).font(.system(size: 14, weight: .bold, design: .default)).fixedSize().padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)).foregroundColor(.white).background(Capsule().fill(color))
    }
}

struct TagView: View{
    
    @State private var availableWidth: CGFloat = 0
    var spacing: CGFloat = 0
    var tags: [TagModel]
    
    func computeRows() -> [[TagModel]] {
        var rows: [[TagModel]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for tag in tags {
            if remainingWidth - (tag.width + spacing) >= 0 {
                rows[currentRow].append(tag)
            } else {
                currentRow = currentRow + 1
                rows.append([tag])
                remainingWidth = availableWidth
            }
            remainingWidth = remainingWidth - tag.width
        }
        return rows
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            VStack(alignment: .leading) {
                ForEach(computeRows(), id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { tag in
                            TagBadge(tag)
                        }
                    }
                }
            }
        }
    }
}

struct TagViewPreview: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    
    var body: some View {
        TagView(tags: items.filter { item in
            item.name == "Test With Box"
        }.first!.tagList)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagViewPreview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
