//
//  john_task_mobileApp.swift
//  john-task-mobile
//
//  Created by Milo Woodman on 7/23/25.
//

import SwiftUI

@main
struct john_task_mobileApp: App {
    @StateObject var briefingVM = BriefingViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView().onAppear {
                    briefingVM.retrieveBriefs()
                }
            }
        }.environmentObject(briefingVM)
    }
}
