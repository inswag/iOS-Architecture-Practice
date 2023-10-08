//
//  TCAPracticeApp.swift
//  TCAPractice
//
//  Created by Insu Park on 10/8/23.
//

import SwiftUI
import ComposableArchitecture

/*
  * TCA Example Notice
   - Once we are ready to display this view, for example in the app's entry point, we can construct a store. This can be done by specifying the initial state to start the application in, as well as the reducer that will power the application:
 */

@main
struct TCAPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            // TCA Basic Usage View
            FeatureView(
                store: Store(initialState: Feature.State()) {
                    Feature()
                }
            )
            
            // TCA Practice View
//            ContentView()
        }
    }
}
