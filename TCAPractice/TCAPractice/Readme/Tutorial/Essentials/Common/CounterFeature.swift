//
//  CounterFeature.swift
//  TCAPractice
//
//  Created by Insu Park on 10/9/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CounterFeature: Reducer {
    
    // MARK: - Required
    // holds the state your feature needs to do its job, typically a struct.
    struct State {
        // For the purpose of a simple counter feature, the state consists of just a single integer, the current count, and the actions consist of tapping buttons to either increment or decrement the count.
        var count = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning = false
    }
    
    // MARK: - Required
    // holds all the actions the user can perform in the feature, typically an enum.
    // Tip - It is best to name the Action cases after literally what the user does in the UI, such as incrementButtonTapped, rather than what logic you want to perform, such as incrementCount.
    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    enum CancelID { case Timer }
    
    /*
     Note

     The reduce method takes State as an argument and it is marked as inout. This means you can make any mutations you want directly to the state. There is no need to make a copy of the state just to return it.
     */
    
    
    // MARK: - Required
    // To finish conforming to Reducer.
    //  Method below evolves the state from its current value to the next value given a user action, and returns any effects that the feature wants to execute in the outside world. This almost always begins by switching on the incoming action to determine what logic you need to perform.
    // We must also return a value of 'Effect' that represents the effect to be executed in the outside world, but in this case we do not need to execute anything.
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none
        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true
            
            // This provides you with an asynchronous context to perform any kind of work you want, as well as a handle (send) for sending actions back into the system.
            return .run { [count = state.count] send in
                // ✅ Do async work in here, and send actions back into the system.
                // Type : (Data, URLResponse)
                let (data, _) = try await URLSession.shared
                  .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                let fact = String(decoding: data, as: UTF8.self)
                await send(.factResponse(fact))
            }
        case let .factResponse(fact):
          state.fact = fact
          state.isLoading = false
          return .none
        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none
        case .timerTick:
          state.count += 1
          state.fact = nil
          return .none
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            
            if state.isTimerRunning {
                return .run { send in
                    while true {
                      try await Task.sleep(for: .seconds(1))
                      await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.Timer)
            } else {
                return .cancel(id: CancelID.Timer)
            }
        }
      }
    
}

/*
  That is all it takes to implement a very basic feature in the Composable Architecture.
 
  There is of course a lot more to know about, such as executing effects and feeding data back into the system, using dependencies in reducers, composing multiple reducers together, and a lot more. 
  But we will stop here for this feature right now and move onto the view.
 */


/*
 < Section 2 - Integrating with SwiftUI >
 
 Now that we have a simple feature built as a reducer, we need to figure out how to power a SwiftUI view from that feature. 
 This involves two new concepts: 'Store', which represents the runtime of the feature, and 'ViewStore', which represents the observation of the runtime.
 */

// View stores require that State be Equatable, so we must do that first. Once the view store is constructed we can access the feature’s state and send it actions when the user taps on buttons.
extension CounterFeature.State: Equatable {}

struct CounterView: View {
    
    // That is generic over the reducer.
    // The 'Store' represents the runtime of your feature.
    // it is the object that can process actions in order to update state, and it can execute effects and feed data from those effects back into the system.
    // Tip - The store can be held onto as a let. It does not need to be observed by the view.
    // Note - You cannot read state from a Store directly, nor can you send actions to it directly. So, for now we will provide stubs for that behavior, but once a ViewStore is added we can provide the real implementations.
    let store: StoreOf<CounterFeature>
    
    // With some basic view scaffolding in place we can now start actually observing state in the 'store'. This is done by constructing a 'ViewStore', and for SwiftUI views there is a convenience view called a 'WithViewStore' that provides a lightweight syntax for constructing a view store.
    
    var body: some View {
        // Tip - Currently we are observing all state in the store by using observe: { $0 }, but typically features hold onto a lot more state than what is needed in the view. See our article Performance for more information on how to best observe only the bare essentials a view needs to do its job.
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    //  that when tapped makes a network request to fetch a fact about the number that is currently displayed.
                }
                Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
                  viewStore.send(.toggleTimerButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                Button("Fact") {
                    viewStore.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
    
}

struct CounterPreview: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(initialState: CounterFeature.State(), reducer: {
                // comment out the CounterFeature reducer and the store will be given a reducer that performs no state mutations or effects. This allows us to preview the design of the feature without worrying about any of its logic or behavior.
                // Conclusion : Using the empty reducer in the preview. if comment out below.
                
                CounterFeature()
//                CounterFeature()
            })
        )
    }
}
