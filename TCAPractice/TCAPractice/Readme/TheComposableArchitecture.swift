//
//  TheComposableArchitecture.swift
//  TCAPractice
//
//  Created by Insu Park on 10/8/23.
//

/*
  - SOURCE REFERENCE : https://github.com/pointfreeco/swift-composable-architecture
 */

// MARK: - Definition

/*
 1. Define
  * The Composable Architecture (TCA, for short)
   - A library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind.
 
 2. What is..?
  * Provides a few core tools that can be used to build applications of varying purpose and complexity.
  * Compelling stories that you can follow to solve many problems you encounter day-to-day when building applications, such as:
    - State management
     # How to manage the state of your application using simple value types
     # How to share state across many screens so that mutations in one screen can be immediately observed in another screen.
    - Composition
     # How to break down large features into smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.
    - Side effects
     # How to let certain parts of the application talk to the outside world in the most testable and understandable way possible.
    - Testing
     # How to not only test a feature built in the architecture, but also write integration tests for features that have been composed of many parts, and write end-to-end tests to understand how side effects influence your application. 
     # This allows you to make strong guarantees that your business logic is running in the way you expect.
    - Ergonomics
     # How to accomplish all of the above in a simple API with as few concepts and moving parts as possible.
 */

// MARK: - Basic Usage

/*
  * To build a feature using the Composable Architecture you define some types and values that model your domain:
   - State: A type that describes the data your feature needs to perform its logic and render its UI.
   - Action: A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.
   - Reducer: A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any effects that should be run, such as API requests, which can be done by returning an Effect value.
   - Store: The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can observe state changes in the store so that you can update UI.
 
  * The benefits of doing this are that you will instantly unlock testability of your feature, and you will be able to break large, complex features into smaller domains that can be glued together.
 */

// MARK: - Reducer

/*
 * As a basic example, consider a UI that shows a number along with "+" and "−" buttons that increment and decrement the number. To make things interesting, suppose there is also a button that when tapped makes an API request to fetch a random fact about that number and then displays the fact in an alert.

 */

import Foundation
import SwiftUI
import ComposableArchitecture

// To implement this feature we create a new type that will house the domain and behavior of the feature by conforming to Reducer:
struct Feature: Reducer {

    // In here we need to define a type for the feature's state, which consists of an integer for the current count, as well as an optional string that represents the title of the alert we want to show (optional because nil represents not showing an alert):
    struct State: Equatable {
      var count = 0
      var numberFactAlert: String?
    }

    // We also need to define a type for the feature's actions. There are the obvious actions, such as tapping the decrement button, increment button, or fact button. But there are also some slightly non-obvious ones, such as the action of the user dismissing the alert, and the action that occurs when we receive a response from the fact API request:
    enum Action: Equatable {
        case factAlertDismissed
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    // And then we implement the reduce method which is responsible for handling the actual logic and behavior for the feature. It describes how to change the current state to the next state, and describes what effects need to be executed. Some actions don't need to execute effects, and they can return .none to represent that:
    func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .factAlertDismissed:
            state.numberFactAlert = nil
            return .none
            
        case .decrementButtonTapped:
            state.count -= 1
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            return .none
            
        case .numberFactButtonTapped:
            return .run { [count = state.count] send in
                let (data, _) = try await URLSession.shared.data(
                    from: URL(string: "http://numbersapi.com/\(count)/trivia")!
                )
                await send(
                    .numberFactResponse(String(decoding: data, as: UTF8.self))
                )
            }
            
        case let .numberFactResponse(fact):
            state.numberFactAlert = fact
            return .none
        }
    }
    
}

/*
  * And then finally we define the view that displays the feature. It holds onto a 'StoreOf<Feature>' so that it can observe all changes to the state and re-render, and we can send all user actions to the store so that state changes. We must also introduce a struct wrapper around the fact alert to make it 'Identifiable', which the '.alert' view modifier requires:
 */

struct FeatureView: View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Button("−") { viewStore.send(.decrementButtonTapped) }
                    Text("\(viewStore.count)")
                    Button("+") { viewStore.send(.incrementButtonTapped) }
                }
                
                Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
                    send: .factAlertDismissed
                ),
                content: { Alert(title: Text($0.title)) }
            )
        }
    }
}

struct FactAlert: Identifiable {
  var title: String
  var id: String { self.title }
}

// MARK: - After adding FeatureView in TCAPracticeApp's body

// And that is enough to get something on the screen to play around with. It's definitely a few more steps than if you were to do this in a vanilla SwiftUI way, but there are a few benefits. It gives us a consistent manner to apply state mutations, instead of scattering logic in some observable objects and in various action closures of UI components. It also gives us a concise way of expressing side effects. And we can immediately test this logic, including the effects, without doing much additional work.

