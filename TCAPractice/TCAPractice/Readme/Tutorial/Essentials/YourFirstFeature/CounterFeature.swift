//
//  CounterFeature.swift
//  TCAPractice
//
//  Created by Insu Park on 10/9/23.
//

import SwiftUI
import ComposableArchitecture

struct CounterFeature: Reducer {
    
    // MARK: - Required
    // holds the state your feature needs to do its job, typically a struct.
    struct State {
        // For the purpose of a simple counter feature, the state consists of just a single integer, the current count, and the actions consist of tapping buttons to either increment or decrement the count.
        var count = 0
    }
    
    // MARK: - Required
    // holds all the actions the user can perform in the feature, typically an enum.
    // Tip - It is best to name the Action cases after literally what the user does in the UI, such as incrementButtonTapped, rather than what logic you want to perform, such as incrementCount.
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
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
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
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
