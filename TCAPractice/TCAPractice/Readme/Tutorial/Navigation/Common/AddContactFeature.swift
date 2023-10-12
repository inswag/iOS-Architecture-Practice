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
        case saveButtonTapped
        case setName(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .none
            
        case .saveButtonTapped:
            return .none
            
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
