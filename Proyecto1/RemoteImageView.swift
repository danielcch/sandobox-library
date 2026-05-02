import SwiftUI

#if canImport(SDWebImageSwiftUI)
import SDWebImageSwiftUI
#endif

struct RemoteImageView: View {
    let url: URL?

    var body: some View {
        Group {
            #if canImport(SDWebImageSwiftUI)
            if let url {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.25))
                    .scaledToFill()
            } else {
                placeholder
            }
            #else
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
            #endif
        }
        .clipped()
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.15)
            Image(systemName: "photo")
                .imageScale(.large)
                .foregroundStyle(.secondary)
        }
    }
}
