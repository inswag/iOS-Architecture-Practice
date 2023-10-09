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
    
    // TCA Tutorial - Your First Feature
    static let store = Store(initialState: CounterFeature.State()) {
        // When used it will print every action that the reducer processes to the console, and it will print how the state changed after processing the action. The method will also go through great lengths to collapse the state difference to a compact form. This includes not displaying nested state if it hasn’t changed, and not showing elements in collections that haven’t changed.
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            // TCA Basic Usage View
//            FeatureView(
//                store: Store(initialState: Feature.State()) {
//                    Feature()
//                }
//            )
            
            // TCA Tutorial - Your First Feature
            CounterView(
                store: TCAPracticeApp.store
            )
            
            // TCA Practice View
//            ContentView()
        }
    }
}
