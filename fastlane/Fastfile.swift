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
            xcodebuildFormatter: "",
            disablePackageAutomaticUpdates: true
        )
    }
    
//	func betaLane() {
//	desc("Push a new beta build to TestFlight")
//		incrementBuildNumber(xcodeproj: "Swiftfin.xcodeproj")
//		buildApp(scheme: "Swiftfin")
//		uploadToTestflight(username: "ethanpippin2343@gmail.com")
//	}
}
