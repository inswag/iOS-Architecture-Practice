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
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    // a single action for when the “+” button is tapped
    enum Action: Equatable {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                return .none
            }
        }
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
