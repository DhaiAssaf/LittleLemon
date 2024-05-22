//
//  Menu.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var dishes: [Dish] = []
    @State var startersIsEnabled = true
    @State var mainsIsEnabled = true
    @State var dessertsIsEnabled = true
    @State var drinksIsEnabled = true
    @State var isShowingUserProfile = false
    @State private var avatarImage: UIImage? = loadImage()
    let customColor = Color(red: 0.286, green: 0.3686, blue: 0.3412)
    
    var body: some View {
        NavigationView{
            VStack {
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Little Lemon")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.yellow)
                            Text("Chicago")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                            
                        }
                        Image("Hero image")
                            .resizable()
                            .frame(maxWidth: 120, maxHeight: 120)
                            .cornerRadius(8)
                        
                    }
                    TextField(" Search", text: $searchText)
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText) { _ in
                            fetchDishes() // Fetch dishes when search text changes
                        }
                        .padding()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(customColor)
                
                
                
                Text("ORDER FOR DELIVERY!")
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Button{
                            startersIsEnabled = true
                            mainsIsEnabled = false
                            dessertsIsEnabled = false
                            drinksIsEnabled = false
                        }label: {
                            Text("Starters")
                                .font(.callout.bold())
                                .foregroundColor(customColor)
                                .padding(5)
                                .background(.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        Button{
                            startersIsEnabled = false
                            mainsIsEnabled = true
                            dessertsIsEnabled = false
                            drinksIsEnabled = false
                        }label: {
                            Text("Mains")
                                .font(.callout.bold())
                                .foregroundColor(customColor)
                                .padding(5)
                                .background(.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        Button{
                            startersIsEnabled = false
                            mainsIsEnabled = false
                            dessertsIsEnabled = true
                            drinksIsEnabled = false
                        }label: {
                            Text("Desserts")
                                .font(.callout.bold())
                                .foregroundColor(customColor)
                                .padding(5)
                                .background(.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        Button{
                            startersIsEnabled = false
                            mainsIsEnabled = false
                            dessertsIsEnabled = false
                            drinksIsEnabled = true
                        }label: {
                            Text("Drinks")
                                .font(.callout.bold())
                                .foregroundColor(customColor)
                                .padding(5)
                                .background(.gray.opacity(0.5))
                                .cornerRadius(8)
                            
                        }
                    }
                    
                    .padding(.horizontal)
                }
                
                FetchedObjects(predicate: buildPredicate(),
                               sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List(dishes) { dish in
                        NavigationLink(destination: DishDetails(dish: dish)) {
                            HStack{
                                VStack(alignment: .leading){
                                    Text(dish.title ?? "")
                                        .font(.custom("Karla", size: 16).weight(.heavy))
                                        .foregroundStyle(.black)
                                    Spacer(minLength: 5)
                                    Text(dish.dishDescription ?? "")
                                        .font(.custom("Karla", size: 14))
                                        .lineLimit(2)
                                    Spacer(minLength: 5)
                                    Text("$\(dish.price ?? "")")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Karla", size: 14).weight(.medium))
                                        .foregroundStyle(.secondary)
                                        .monospaced()
                                }
                                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(maxWidth: 80, maxHeight: 80)
                                .clipShape(Rectangle())
                            }}
                    }
                    .listStyle(.plain)
                }
                
            } .padding()
                .onAppear {
                    getMenuData()
                    fetchDishes()
                }
            
            
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        
                        Image("Logo")
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                        } label: {
                            Image(uiImage: avatarImage ?? UIImage(named: "Profile")!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 55, height: 55)
                            
                        }
                        
                    }
                    
                }
            
        }
    }
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title",
                                 ascending: true,
                                 selector:
                                    #selector(NSString.localizedStandardCompare))]
    }
    func buildPredicate() -> NSPredicate {
        // Search predicate: checks if searchText is empty, and if not, creates a predicate for it.
        let searchPredicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        // Category predicates: each checks if the corresponding category is enabled.
        var categoryPredicates: [NSPredicate] = []
        
        if startersIsEnabled {
            categoryPredicates.append(NSPredicate(format: "category == %@", "starters"))
        }
        if mainsIsEnabled {
            categoryPredicates.append(NSPredicate(format: "category == %@", "mains"))
        }
        if dessertsIsEnabled {
            categoryPredicates.append(NSPredicate(format: "category == %@", "desserts"))
        }
        if drinksIsEnabled {
            categoryPredicates.append(NSPredicate(format: "category == %@", "drinks"))
        }
        
        // If no categories are enabled, use a false predicate to show nothing.
        let categoryCompoundPredicate = categoryPredicates.isEmpty ? NSPredicate(value: false) : NSCompoundPredicate(orPredicateWithSubpredicates: categoryPredicates)
        
        // Combine search and category predicates using "AND".
        return NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, categoryCompoundPredicate])
        
    }
    
    
    
    func clearDatabase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Error occurred while clearing the database: \(error.localizedDescription)")
        }
    }
    
    func getMenuData() {
        
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true) // Fetch all for simplicity in this example
        
        do {
            let existingDishes = try viewContext.fetch(fetchRequest)
            if existingDishes.isEmpty {
                fetchDataFromAPI()
            } else {
                print("Using cached data")
            }
        } catch {
            print("Failed to fetch existing dishes: \(error)")
            fetchDataFromAPI() // Attempt to fetch from API if local fetch fails
        }
    }
    
    func fetchDataFromAPI() {
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {  data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Request returned non-200 status")
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let menuList = try decoder.decode(MenuList.self, from: data)
                    DispatchQueue.main.async {
                        clearDatabase()
                        for menuItem in menuList.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.dishDescription = menuItem.dishDescription  // Use the new property name
                            dish.price = menuItem.price
                            dish.image = menuItem.image
                            dish.category = menuItem.category
                        }
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print("Failed to save context: \(error.localizedDescription)")
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    func fetchDishes() {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.sortDescriptors = buildSortDescriptors()
        fetchRequest.predicate = buildPredicate()
        
        do {
            dishes = try viewContext.fetch(fetchRequest)
            print("Fetched dishes: \(dishes.count)")
        } catch {
            print("Failed to fetch dishes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    Menu()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
