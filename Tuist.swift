import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        generationOptions: .options(
            defaultConfiguration: "Debug",
            additionalPackageResolutionArguments: ["-scmProvider", "system"]
        ),
        cacheOptions: .options(
            keepSourceTargets: false,
            profiles: .profiles(
                [
                    "development": .profile(.onlyExternal),
                    "ci-all-possible": .profile(.allPossible),
                ],
                default: .onlyExternal
            )
        )
    )
)
