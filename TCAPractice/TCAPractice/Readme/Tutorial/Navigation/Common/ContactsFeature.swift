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
        var contacts: IdentifiedArrayOf<Contact> = []
        
        // Integrating destinations
//        @PresentationState var addContact: AddContactFeature.State?
//        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var destination: Destination.State?
        
        /* 
          * StackState
            - Generic of the feature that you want to be able to push onto the stack.
          NOTE)
            - The StackState type is specifically made for the Composable Architecture, and makes it easy and ergonomic to integrate stack navigation into your applications.
         */
        var path = StackState<ContactDetailFeature.State>()
    }
    
    enum Action: Equatable {
        // a single action for when the “+” button is tapped
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        
        // Integrate the feature’s actions together
        // This allows the parent to observe every action sent from the child feature.
        // But this will be replaced with a single case that holds onto Destination.Action.
//        case addContact(PresentationAction<AddContactFeature.Action>)
//        case alert(PresentationAction<Alert>)
        case destination(PresentationAction<Destination.Action>)
        
        // the actions that can happen inside the stack, such as pushing or popping an element off the stack, or an action happening inside a particular feature inside the stack.
        case path(StackAction<ContactDetailFeature.State, ContactDetailFeature.Action>)
        
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
            // Note - The only choices in the alert are to cancel or confirm deletion, but we do not need to model the cancel action. That will be handled automatically for us.
        }
    }
    
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: UUID(), name: "")
                    )
                )
            
                return .none
                
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
//            case .addContact(.presented(.delegate(.cancel))):
                // When the “Cancel” button is tapped inside the “Add Contacts” feature we want to dismiss the feature and do nothing else. This can be accomplished by simply nil-ing out the addContact state.
//                state.addContact = nil
//                return .none
                // Note - We are destructuring on the PresentationAction.presented(_:) case in order to listen for actions inside the “Add Contact” feature.
//            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                // guard let contact = state.addContact?.contact
                // else { return .none }
//                state.contacts.append(contact)
//                state.addContact = nil
//                return .none
                
                /*
                 - After applying .saveContact(Contact)...
                 The application should work exactly as it did before the “delegate action” refactor, but now the child feature can accurately describe what it wants the parent to do rather than the parent make assumptions. There is still room for improvement though. It is very common for a child feature to want to dismiss itself, such as is the case when tapping “Cancel”. It is too cumbersome to create a delegate action just to communicate this to the parent, and so the library comes with a special tool for this.
                 */
//            case .addContact:
//                return .none
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            case .path:
              return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        .forEach(\.path, action: /Action.path) {
          ContactDetailFeature()
        }
        
        // .forEach : operator to integrate the ContactDetailFeature into the stack of the ContactsFeature.
        
//        .ifLet(\.$addContact, action: /Action.addContact) {
//            AddContactFeature()
//        }
//        .ifLet(\.$alert, action: /Action.alert)
        
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

extension ContactsFeature {
    
    // Will hold the domain and logic for every feature that can be navigated to from the contacts feature.
    struct Destination: Reducer {
        // want to express the fact that only one single destination can be active at a time, and enums are perfect for that.
        enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        
        enum Action: Equatable {
            // for each destination feature that can be navigated to, and hold onto that feature’s action.
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        
        var body: some ReducerOf<Self> {
            // Compose all of the destination features together by using the 'Scope' reducer to focus on the domain of a reducer.
            Scope(state: /State.addContact, action: /Action.addContact) {
                AddContactFeature()
            }
            
            // Typically you will need one Scope reducer for each destination except for alerts and confirmation dialogs since they do not have a reducer of their own.
        }
    }
}

struct ContactsView: View {
    
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        // NavigationStackStore : This is a type specifically tuned for driving stacks from a Store. You hand it a store that is scoped down to StackState and StackAction, and it handles the rest.
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0)})) {
            // Observes the store in order to show a list of contacts and send actions.
            WithViewStore(self.store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        NavigationLink(state: ContactDetailFeature.State(contact: contact)) {
                            HStack {
                                Text(contact.name)
                                Spacer()
                                Button {
                                    viewStore.send(.deleteButtonTapped(id: contact.id))
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .buttonStyle(.borderless)
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
        } destination: { store in
            ContactDetailView(store: store)
        }
        .sheet(
            store: self.store.scope(state: \.$destination, action: { .destination($0) }),
            state: /ContactsFeature.Destination.State.addContact,
            action: ContactsFeature.Destination.Action.addContact, content: { addContactStore in
                NavigationStack {
                    AddContactView(store: addContactStore)
                }
            }
        )
        .alert(
              store: self.store.scope(state: \.$destination, action: { .destination($0) }),
              state: /ContactsFeature.Destination.State.alert,
              action: ContactsFeature.Destination.Action.alert
        )

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
