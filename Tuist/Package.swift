// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings()
#endif

let package = Package(
    name: "Proyecto1Dependencies",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "12.12.1"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.54.5"),
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc", exact: "2.6.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", exact: "3.1.4"),
    ]
)
