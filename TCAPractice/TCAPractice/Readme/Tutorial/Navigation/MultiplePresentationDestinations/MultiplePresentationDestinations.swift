//
//  MultiplePresentationDestinations.swift
//  TCAPractice
//
//  Created by Insu Park on 10/15/23.
//

/*
  * Multiple presentation destinations
   - In the previous section you learned how model your domains so that a parent feature can present a child feature. Now let’s learn what has to be done if a parent feature wants to be able to present many features.
 
  < Section 1 - Delete contacts >
   * Introduction
    - Let’s add a new feature to the contacts list that allows you to delete a contact, but first you must confirm deletion. We will implement the confirmation step using an alert. The tools that we used last section, such as 'PresentationState', 'PresentationAction' and 'ifLet', all work for presenting alerts from optional state too.
 
  < Section 2 - Improve domain modeling >
 
   * Introduction
    - Currently the ContactsFeature can navigate to two possible destinations: 
     * “Add Contact” sheet
     * the delete alert.
   
    - Importantly, it is not possible to be navigated to both destinations at once. However, that currently is possible since we are representing each of those destinations as optional pieces of 'PresentationState'.
    
    - The number of invalid states explodes exponentially when you use optionals to represent features you can navigate to. 
     * For example, 2 optionals has 1 invalid state, but 3 optionals has 4 invalid states, and 4 optionals has 11 invalid states. This imprecise domain modeling leaks complexity into your application since you can never truly know which feature is being presented.

    Let’s see how to more concisely model our domains for navigating to multiple destinations.
 */
