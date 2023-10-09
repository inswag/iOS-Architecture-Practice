//
//  Essentials-YourFirstFeature-Introduction.swift
//  TCAPractice
//
//  Created by Insu Park on 10/9/23.
//

/*
 
 < Essentials - Your first feature >
 
  - Learn how to create a conformance to the 'Reducer' protocol for implementing the logic and behavior of a feature, and then learn how to hook up that feature to a SwiftUI view.
 
  < Section 1 - Create a reducer >
 
  - The fundamental unit that features are built with in the Composable Architecture is the 'Reducer'. A conformance to that protocol represents the logic and behavior for a feature in your application. This includes how to evolve the current state to the next state when an action is sent into the system, and how effects communicate with the outside world and feed data back into the system.
 
  - And most importantly, the feature’s core logic and behavior can be built in full isolation with no mention of a SwiftUI view, which makes it easier to develop in isolation, easier to reuse, and easier to test.

  - Let’s start by creating a simple reducer that encapsulates the logic of a counter. We will add more interesting behavior to the feature, but let’s start simple for now.
 
  < Summary >
  - 'Reducer' is the fundamental unit of TCA. A conformance of 'Reducer' protocol is logic and behavior for a feature and it's a method to evolve the current state to the next state when an action is sent into system and how effects communicate with the outside world and feed data back into the system.
  - The feature’s core logic and behavior can be built in full isolation with no mention of a SwiftUI view. This feature can make it easier in isolation, reuse, test.
 
 */

