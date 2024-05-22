//
//  Home.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView{
            Menu()
                .tabItem { Label("Menu", systemImage: "list.dash") }
            UserProfile()
            
                .tabItem { Label("Profile", systemImage: "square.and.pencil") }
        } .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()        
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    
}
