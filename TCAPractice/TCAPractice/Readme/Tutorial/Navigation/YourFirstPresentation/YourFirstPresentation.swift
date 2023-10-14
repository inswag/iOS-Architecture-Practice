//
//  YourFirstPresentation.swift
//  TCAPractice
//
//  Created by Insu Park on 10/12/23.
//

import Foundation

/*
 < Navigation - Your first presentation >
 
 * Introduction
  - The Composable Architecture offers a variety of tools to help you present child features from parent features. To begin, we will explore presenting a feature that is driven off of optional state.
 
 */

/*
 < Section 1 - Project set up >
 
 * Introduction
  - Suppose that you are working on an application that shows a list of contacts at the root, and you want to add the ability to create a new contact. This should be done by tapping a “+” icon in the UI, a sheet will be presented where you can enter the contact’s info, and then tapping a button will dismiss the sheet and add the contact to the list.
 */


/*
 < Section 2 - Integrate reducers >
 
 * Introduction
  - Now that we have our two isolated features built, it is time to integrate them together so that you can navigate to the “Add Contact” screen from the contacts list screen. To do this we will first integrate the features’ reducers, which consists of utilizing 'PresentationState' and 'PresentationAction' to integrate the domains, and the reducer operator 'ifLet(_:action:destination:fileID:line:)' to integrate the reducers.
 
 */

/*
  < Section 3 - Integrate views >
 
  * Introduction
   - Now that we have integrated the domain and reducers of the two features we must integrate their views. In particular, we will present an AddContactView from the ContactsView.
 
 */

/*
 < Section 4 - Child-to-parent communication >
 
 * Introduction
  - Problem)
   # In the previous sections we facilitated child-to-parent communication by having the parent reducer inspect the actions in the child so that we could determine when the “Save” and “Cancel” buttons were tapped.
    -> This is not ideal since it may lead to the parent making assumptions about what logic it should perform when something happens in the child feature.

   - Solution)
    # A better pattern is to use so-called “delegate actions” for the child feature to directly tell the parent what it wants done.
 */
