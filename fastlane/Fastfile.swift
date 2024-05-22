// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {

    func iOSTestFlightLane(withOptions options: [String: String]?) {

        // TODO: print required options
//        guard let options else {
//            puts(message: "ERROR: options are necessary")
//            exit(1)
//        }

//        guard let version = options["version"] else {
//            puts(message: "ERROR: `version` option required")
//            exit(1)
//        }

        desc("Deploy iOS Swiftfin to TestFlight")

        incrementBuildNumber(xcodeproj: "Swiftfin.xcodeproj")

        updateProjectTeam(
            path: "Swiftfin.xcodeproj",
            teamid: "TY84JMYEFE"
        )
        
        buildApp(
            scheme: "Swiftfin",
            configuration: "Debug",
            skipArchive: .userDefined(true),
            xcodebuildFormatter: "",
            disablePackageAutomaticUpdates: true
        )

        buildApp(
            scheme: "Swiftfin tvOS",
            configuration: "Debug",
            skipArchive: .userDefined(true),
            xcodebuildFormatter: "",
            disablePackageAutomaticUpdates: true
        )
        
        uploadToTestflight(
            apiKeyPath: <#T##OptionalConfigValue<String?>#>,
            apiKey: <#T##OptionalConfigValue<[String : Any]?>#>,
            username: <#T##OptionalConfigValue<String?>#>,
            appIdentifier: <#T##OptionalConfigValue<String?>#>,
            appPlatform: <#T##OptionalConfigValue<String?>#>,
            appleId: <#T##OptionalConfigValue<String?>#>,
            ipa: <#T##OptionalConfigValue<String?>#>,
            pkg: <#T##OptionalConfigValue<String?>#>,
            demoAccountRequired: <#T##OptionalConfigValue<Bool?>#>,
            betaAppReviewInfo: <#T##OptionalConfigValue<[String : Any]?>#>,
            localizedAppInfo: <#T##OptionalConfigValue<[String : Any]?>#>,
            betaAppDescription: <#T##OptionalConfigValue<String?>#>,
            betaAppFeedbackEmail: <#T##OptionalConfigValue<String?>#>,
            localizedBuildInfo: <#T##OptionalConfigValue<[String : Any]?>#>,
            changelog: <#T##OptionalConfigValue<String?>#>,
            skipSubmission: <#T##OptionalConfigValue<Bool>#>,
            skipWaitingForBuildProcessing: <#T##OptionalConfigValue<Bool>#>,
            updateBuildInfoOnUpload: <#T##OptionalConfigValue<Bool>#>,
            distributeOnly: <#T##OptionalConfigValue<Bool>#>,
            usesNonExemptEncryption: <#T##OptionalConfigValue<Bool>#>,
            distributeExternal: <#T##OptionalConfigValue<Bool>#>,
            notifyExternalTesters: <#T##Any?#>,
            appVersion: <#T##OptionalConfigValue<String?>#>,
            buildNumber: <#T##OptionalConfigValue<String?>#>,
            expirePreviousBuilds: <#T##OptionalConfigValue<Bool>#>,
            firstName: <#T##OptionalConfigValue<String?>#>,
            lastName: <#T##OptionalConfigValue<String?>#>,
            email: <#T##OptionalConfigValue<String?>#>,
            testersFilePath: <#T##String#>,
            groups: <#T##OptionalConfigValue<[String]?>#>,
            teamId: <#T##Any?#>,
            teamName: <#T##OptionalConfigValue<String?>#>,
            devPortalTeamId: <#T##OptionalConfigValue<String?>#>,
            itcProvider: <#T##OptionalConfigValue<String?>#>,
            waitProcessingInterval: <#T##Int#>,
            waitProcessingTimeoutDuration: <#T##OptionalConfigValue<Int?>#>,
            waitForUploadedBuild: <#T##OptionalConfigValue<Bool>#>,
            rejectBuildWaitingForReview: <#T##OptionalConfigValue<Bool>#>,
            submitBetaReview: <#T##OptionalConfigValue<Bool>#>
        )
    }

    //	func betaLane() {
    //	desc("Push a new beta build to TestFlight")
    //		incrementBuildNumber(xcodeproj: "Swiftfin.xcodeproj")
    //		buildApp(scheme: "Swiftfin")
    //		uploadToTestflight(username: "ethanpippin2343@gmail.com")
    //	}
}
