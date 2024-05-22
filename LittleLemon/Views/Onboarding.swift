//
//  ContentView.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI
import CoreData

let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kIsLoggedIn = "kIsLoggedIn"
let kPhoneNumber = "phone_number_key"

struct Onboarding: View {
    @State private var isLoggedin: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    let customColor = Color(red: 0.286, green: 0.3686, blue: 0.3412)

    var body: some View {
        NavigationView{
            VStack{
                Image("Logo")
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
                .padding()
                .frame(maxWidth: .infinity)
                .background(customColor)
                Spacer()
                NavigationLink(destination: Home(), isActive: $isLoggedin){
                    EmptyView()
                }
                Text("ORDER NOW!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                VStack(spacing: 20){
                    TextField("First Name*" , text: $firstName )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Last Name*" , text: $lastName )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Email" , text: $email )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Phone Number*" , text: $phoneNumber )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
                    Spacer()
                    Button("Register"){
                        if !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            isLoggedin = true
                        } else {
                            print("Error")
                        }
                    } .padding()
                        .frame(width: 300 , height: 50)
                        .font(.headline)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } .padding()
                Spacer()
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedin = true
                }
            }
            
            
            
        }
    }
}

#Preview {
    Onboarding()
    
}
