//
//  CounterFeatureTests.swift
//  TCAPractice
//
//  Created by Insu Park on 10/10/23.
//

import ComposableArchitecture
//import XCTest
//
//@MainActor
//final class CounterFeatureTests: XCTestCase {
//    
//    // preemptively make the test method 'async' because the testing tools of the Composable Architecture do make use of asynchrony.
//    func testCounter() async {
//        // TestStore : a tool that makes it easy to assert on how the behavior of your feature changes as actions are sent into the system.
//        let store = TestStore(initialState: CounterFeature.State()) {
//            CounterFeature()
//        }
//        
//        // The send(_:assert:file:line:) method on the test store is 'async' because most features involve asynchronous side effects, and the test store using the async context to track those effects.
//        await store.send(.incrementButtonTapped) {
//          $0.count = 1
//        }
//        await store.send(.decrementButtonTapped) {
//          $0.count = 0
//        }
//    }
//    
//}
