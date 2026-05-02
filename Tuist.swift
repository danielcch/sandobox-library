import Foundation
import ProjectDescription

func remoteHandle() -> String? {
    let handle = Environment.fullHandle.getString(default: "").trimmingCharacters(in: .whitespacesAndNewlines)
    return handle.isEmpty ? nil : handle
}

let tuist = Tuist(
    fullHandle: remoteHandle(),
    project: .tuist(
        generationOptions: .options(
            defaultConfiguration: "Debug",
            optionalAuthentication: true,
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
