//
//  ContactsFeature.swift
//  TCAPractice
//
//  Created by Insu Park on 10/12/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

// a simple Contact model data type
struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

// We conform State and Action to the Equatable protocol in order to test this feature later.
struct ContactsFeature: Reducer {
    
    // a simple reducer with a collection of contacts
    struct State: Equatable {
        // Integrate the features’ states together by using the PresentationState property wrapper to hold onto an optional value.
        // A nil value represents that the “Add Contacts” feature is not presented, and a non-nil value represents that it is presented.
        @PresentationState var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    
    enum Action: Equatable {
        // a single action for when the “+” button is tapped
        case addButtonTapped
        // Integrate the feature’s actions together
        // This allows the parent to observe every action sent from the child feature.
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none
//            case .addContact(.presented(.delegate(.cancel))):
                // When the “Cancel” button is tapped inside the “Add Contacts” feature we want to dismiss the feature and do nothing else. This can be accomplished by simply nil-ing out the addContact state.
//                state.addContact = nil
//                return .none
                // Note - We are destructuring on the PresentationAction.presented(_:) case in order to listen for actions inside the “Add Contact” feature.
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                // guard let contact = state.addContact?.contact
                // else { return .none }
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
                
                /*
                 - After applying .saveContact(Contact)...
                 The application should work exactly as it did before the “delegate action” refactor, but now the child feature can accurately describe what it wants the parent to do rather than the parent make assumptions. There is still room for improvement though. It is very common for a child feature to want to dismiss itself, such as is the case when tapping “Cancel”. It is too cumbersome to create a delegate action just to communicate this to the parent, and so the library comes with a special tool for this.
                 */
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
        
        // Integrate the reducers together by making use of the ifLet(_:action:destination:fileID:line:) reducer operator.
        
        /*
         About Above Method (.ifLet)
         * This creates a new reducer that runs the child reducer when a child action comes into the system, and runs the parent reducer on all actions. It also automatically handles effect cancellation when the child feature is dismissed, and a lot more. See the documentation for more information.
         
         After doing that
         * That is all it takes to integrate the two features’ domains together. Before moving onto the view, we can start flexing some of the muscles that the library gives us. Because the two features are so tightly integrated together we can now easily implement the presentation and dismissal of the “Add Contact” feature.
         */
        
        /*
         After All doing that, finally...
         * That is all it takes to implement communication between parent and child features. The parent feature can create state in order to drive navigation, and the parent feature can listen for child actions to figure out what additional logic it wants to layer on. Next we need to integrate the views together.
         */
    }
}

struct ContactsView: View {
    
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            // Observes the store in order to show a list of contacts and send actions.
            WithViewStore(self.store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        Text(contact.name)
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(
            store: self.store.scope(
                state: \.$addContact,
                action: { .addContact($0) }
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }

        /*
          * Before using method .sheet ..
           - The library comes with a variety of tools that mimic SwiftUI’s native navigation tools (such as sheets, popovers, fullscreen covers, alerts, and confirmation dialogs), but they take Stores instead of bindings.
         
          * About method .sheet (a little difficult to understand this sentence)
           - Use the sheet(store:) view modifier by scoping your store down to just the presentation domain of the addContact feature. When the addContact state becomes non-nil, a new store will be derived focused only on the AddContactFeature domain, which is what you can pass to the AddContactView.
         */
    }
    
}

struct ContactsView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsView(
      store: Store(
        initialState: ContactsFeature.State(
          contacts: [
            Contact(id: UUID(), name: "Blob"),
            Contact(id: UUID(), name: "Blob Jr"),
            Contact(id: UUID(), name: "Blob Sr"),
          ]
        )
      ) {
        ContactsFeature()
      }
    )
  }
}