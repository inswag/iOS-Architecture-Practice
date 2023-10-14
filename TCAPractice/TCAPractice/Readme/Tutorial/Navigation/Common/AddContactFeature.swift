//
//  AddContactFeature.swift
//  TCAPractice
//
//  Created by Insu Park on 10/12/23.
//

import SwiftUI
import ComposableArchitecture

// Will hold the reducer and view for the feature that allows us to enter the name of a new contact.
struct AddContactFeature: Reducer {
    
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        
        // This enum will describe all the actions that the parent can listen for and interpret. It allows the child feature to directly tell the parent what it wants done.
        enum Delegate: Equatable {
//            case cancel
            // Remove the cancel action from the Delegate enum because it is no longer needed. We do not need to explicitly communicate to the parent that it should dismiss the child. That is all handled by the 'DismissEffect'.
            case saveContact(Contact)
        }
    }
    
    // About variable below : This is a value that allows child features to dismiss themselves without any direct contact with the parent feature.
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
//            return .send(.delegate(.cancel))
            return .run { _ in await self.dismiss() }
            // Use the dismiss dependency by returning an effect and invoking it. This will communicate with the parent in order for a PresentationAction.dismiss action to be sent, which will clear out the state driving the presentation.
            // Note : The dismiss dependency is asynchronous which means it is only appropriate to invoke from an effect.
        case .delegate:
            return .none
        case .saveButtonTapped:
//            return .send(.delegate(.saveContact(state.contact)))
            return .run { [contact = state.contact] send in
                await send(.delegate(.saveContact(contact)))
                await self.dismiss()
            }
        case let .setName(name):
            state.contact.name = name
            return .none
        }
    }
    
}

// Add a view that holds onto a Store of the AddContactFeature and observes the state in order to show a text field for the contact name and send actions.
struct AddContactView: View {
    
    let store: StoreOf<AddContactFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
                Button("Save") {
                    viewStore.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
    
}

struct AddContactPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddContactView(
                store: Store(
                    initialState: AddContactFeature.State(
                        contact: Contact(
                            id: UUID(),
                            name: "Blob"
                        )
                    )
                ) {
                    AddContactFeature()
                }
            )
        }
    }
}
