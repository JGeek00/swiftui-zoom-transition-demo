import SwiftUI

struct DetailsView: View {
    var transitionId: Namespace.ID
    var itemNumber: Int
    var onClose: () -> Void
    
    init(transitionId: Namespace.ID, itemNumber: Int, onClose: @escaping () -> Void) {
        self.transitionId = transitionId
        self.itemNumber = itemNumber
        self.onClose = onClose
    }
    
    @State var scrollPosition = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollReader in
                ScrollView {
                    Image(uiImage: .wallpaper)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 400)
                        .clipped()
                        .overlay(alignment: .topLeading) {
                            Group {
                                Button {
                                    onClose()
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.buttonForeground)
                                        .fontWeight(.semibold)
                                        .padding(8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .background(Material.thin)
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                            }
                            .position(x: 27, y: geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top + (27/2) : 27)
                        }
                        .id("top-image")
                    Spacer()
                        .frame(height: 24)
                    VStack(alignment: .leading) {
                        Text("Image #\(itemNumber)")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        Spacer()
                            .frame(height: 12)
                        Text(lorem)
                    }
                    .padding(.horizontal, 12)
                    .frame(width: .infinity)
                }
                .onScrollGeometryChange(for: Double.self, of: { geometry in
                    return geometry.contentOffset.y
                }, action: { oldValue, newValue in
                    scrollPosition = newValue
                })
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            scrollReader.scrollTo("top-image", anchor: .top)
                        }
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.buttonForeground)
                            .fontWeight(.semibold)
                            .padding(12)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .background(Color.buttonBackground)
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
                    .padding(12)
                    .offset(x: 0, y: scrollPosition > 50 ? 0 : 100)
                    .animation(.easeOut(duration: 0.2), value: scrollPosition)
                }
            }
            .navigationTransition(.zoom(sourceID: "card-\(itemNumber)", in: transitionId))
            .edgesIgnoringSafeArea(.top)
        }
    }
}
