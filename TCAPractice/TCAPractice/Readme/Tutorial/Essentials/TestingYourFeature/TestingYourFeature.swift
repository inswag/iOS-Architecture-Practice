//
//  TestingYourFeature.swift
//  TCAPractice
//
//  Created by Insu Park on 10/10/23.
//

/*
 < Essentials - Testing your feature >
 
 * Intro
  - Learn how to write test for the counter built in previous tutorials
   # how to assert against state changes.
   # how effects execute and feed data back into the system.
 */

/*
  < Section 1 - Testing state changes >
 
  * The only thing that needs to be tested for features built in the Composable Architecture is the reducer, and that comes down to testing two things:
   # How state mutates when actions are sent
   # How effects are executed and feed their data back into the reducer.

  * State changes are by far the easiest part to test in the Composable Architecture since reducers form a pure function. All you need to do is feed a piece of state and an action to the reducer and then assert on how the state changed.

  * But, the Composable Architecture makes an easy process even easier thanks to the 'TestStore'. The test store is a testable runtime for your feature that monitors everything happening inside the system as you send actions, making it possible for you to write simple assertions, and when your assertion fails it provides a nicely formatted failure message.

 */
