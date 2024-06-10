//
//  HomeViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var drivers : [UserItem] = []
    
    init() {
        fetchDriverUsers()
    }
    
    func fetchDriverUsers() {
        Firestore.firestore()
            .collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Could not retrive Driver \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                self.drivers = documents.compactMap({ try? $0.data(as: UserItem.self)})
            }
        
    }
}
