//
//  ContentView.swift
//  john-task-mobile
//
//  Created by Milo Woodman on 7/23/25.
//

import SwiftUI

struct ContentView: View {
    // if there were more to this file,
    // this would be in a viewmodel as well
    @State var showBriefs = false
    
    @EnvironmentObject private var briefingVm: BriefingViewModel
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            Button(action: {
                showBriefs.toggle()
                self.briefingVm.retrieveBriefs()
            }, label: {
                Text("view briefs")
            }).matchedTransitionSource(id: "link", in: namespace)
        }.navigationDestination(
            isPresented: Binding(
                get: {
                    return showBriefs && briefingVm.loaded
                },
                set: { val in
                    showBriefs = val;
                }
            ),
            destination: {
                BriefingView()
                    .navigationTransition(.zoom(sourceID: "link", in: namespace))
                    .navigationBarBackButtonHidden()
            }
        )
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }.environmentObject(BriefingViewModel())
}
