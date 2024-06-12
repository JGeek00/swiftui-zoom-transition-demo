import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(1...10, id: \.self) { item in
                            Entry(itemNumber: item, width: geometry.size.width)
                        }
                    }
                    .padding(.horizontal, 12)
                    .fontDesign(.rounded)
                }
            }
        }
    }
}

private struct Entry: View {
    var itemNumber: Int
    var width: Double
    
    init(itemNumber: Int, width: Double) {
        self.itemNumber = itemNumber
        self.width = width
    }
    
    @Namespace private var transitionId
    @State private var showingSheet = false
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            Image(uiImage: .wallpaper)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width - 24, height: 300)
                .clipped()
                .overlay(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("Image #\(itemNumber)")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 4)
                        Text(loremP)
                            .font(.system(size: 14))
                    }
                    .padding(12)
                    .frame(width: width - 24, height: 120)
                    .background(.thinMaterial)
                }
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: "card-\(itemNumber)", in: transitionId)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.7), radius: 12)
        .contextMenu {
            Button {
                showingSheet.toggle()
            } label: {
                Label("Open", systemImage: "rectangle")
            }
        }
        .fullScreenCover(isPresented: $showingSheet) {
            DetailsView(transitionId: transitionId, itemNumber: itemNumber) {
                showingSheet.toggle()
            }
        }
    }
}
