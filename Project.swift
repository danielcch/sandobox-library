import ProjectDescription

func targetSettings() -> Settings {
    .settings(
        base: [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            "CODE_SIGN_STYLE": "Automatic",
            "CURRENT_PROJECT_VERSION": "1",
            "DEVELOPMENT_TEAM": "A6S6G97MVN",
            "ENABLE_PREVIEWS": "YES",
            "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            "MARKETING_VERSION": "1.0",
            "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            "SWIFT_EMIT_LOC_STRINGS": "YES",
            "SWIFT_VERSION": "5.0",
        ],
        configurations: [
            .debug(
                name: "Debug",
                settings: [
                    "ENABLE_TESTABILITY": "YES",
                    "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
                    "ONLY_ACTIVE_ARCH": "YES",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG $(inherited)",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                ]
            ),
            .release(
                name: "Release",
                settings: [
                    "ENABLE_NS_ASSERTIONS": "NO",
                    "MTL_ENABLE_DEBUG_INFO": "NO",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "VALIDATE_PRODUCT": "YES",
                ]
            ),
        ],
        defaultSettings: .recommended
    )
}

let project = Project(
    name: "Proyecto1",
    organizationName: "Daniel",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "A6S6G97MVN",
            "IPHONEOS_DEPLOYMENT_TARGET": "26.2",
            "SWIFT_VERSION": "5.0",
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "Proyecto1",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.test.binary.Proyecto1",
            deploymentTargets: .iOS("26.2"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSupportsIndirectInputEvents": true,
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                ]
            ),
            sources: ["Proyecto1/**/*.swift"],
            resources: ["Proyecto1/Assets.xcassets"],
            dependencies: [
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseFirestore"),
                .external(name: "Realm"),
                .external(name: "RealmSwift"),
                .external(name: "MSAL"),
                .external(name: "SDWebImage"),
                .external(name: "SDWebImageSwiftUI"),
            ],
            settings: targetSettings()
        ),
    ],
    additionalFiles: ["Proyecto1/README.md"]
)
