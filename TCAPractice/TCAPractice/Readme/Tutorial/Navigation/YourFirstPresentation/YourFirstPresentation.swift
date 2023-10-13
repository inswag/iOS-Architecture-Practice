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
