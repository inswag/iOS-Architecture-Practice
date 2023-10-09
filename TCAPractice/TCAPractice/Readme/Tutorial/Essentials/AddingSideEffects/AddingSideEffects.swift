//
//  AddingSideEffects.swift
//  TCAPractice
//
//  Created by Insu Park on 10/9/23.
//

/*
 < Section 1 - What is a side effect? >
 
 * Definition
  - Side effects are by far the most important aspect of feature development. 
  - They are what allow us to communicate with the outside world, such as making API requests, interacting with file systems, and performing time-based asynchrony. Without them, our applications could not do anything of real value for our users.
  - However, side effects are also the most complex part of our features. State mutations are simple processes. If you run the reducer with the same piece of state and same action, you will always get the same result. But effects are susceptible(영향을 받기 쉬운) to the vagaries(엉뚱한 변화) of the outside world, such as network connectivity, disk permissions, and more. Each time you run an effect, you can get back a completely different answer.
  
  Let’s start by seeing why we can’t simply perform effectful work directly in our 'Reducer' conformances, and then we will see what tools the library provides for performing effects.
 */


/*
 < Section 2 - Performing a network request >
 
 * Introduction
  - Now that we understand what a side-effect is and why they cannot be performed directly in a reducer, let’s see how to fix the code we wrote above.

 * Effect ?
  - The Composable Architecture bakes the notion of “effect” directly into the definition of 'Reducer'.
  - After a reducer processes an action by mutating state, it can return something called an 'Effect', which represents an asynchronous unit that is run by the 'Store'.
  - Effects are what can communicate with outside systems and then feed data from the outside back into the reducer.

  This is exactly what we want to do for our number fact effect. We want to make a network request, and then feed that information back into the reducer. So, let’s get started.
 */
