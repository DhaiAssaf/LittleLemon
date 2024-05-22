//
//  DishDetails.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI
import CoreData

struct DishDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    let dish: Dish
    
    var body: some View {
        Spacer()
        ScrollView {
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .padding()
            .clipShape(Rectangle())
            .frame(minHeight: 150)
            Text(dish.title ?? "")
            
            Spacer(minLength: 20)
            Text(dish.dishDescription ?? "")
            
            Spacer(minLength: 10)
            Text("$" + (dish.price ?? ""))
            
                .monospaced()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    DishDetails(dish: Dish())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
