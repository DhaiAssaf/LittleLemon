//
//  UserProfile.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import SwiftUI

struct UserProfile: View {
    @State private var firstName: String = UserDefaults.standard.string(forKey: "first_name_key") ?? ""
    @State private var lastName: String = UserDefaults.standard.string(forKey: "last_name_key") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "email_key") ?? ""
    @State private var phoneNumber: String = UserDefaults.standard.string(forKey: "phone_number_key") ?? ""
    @State private var avatarImage: UIImage? = loadImage()
 
    @State private var orderStatus: Bool = UserDefaults.standard.bool(forKey: "orderStatus")
    @State private var passwordChanges: Bool = UserDefaults.standard.bool(forKey: "passwordChanges")
    @State private var specialOffers: Bool = UserDefaults.standard.bool(forKey: "specialOffers")
    @State private var newsletter: Bool = UserDefaults.standard.bool(forKey: "newsletter")
    
    @State private var showingImagePicker = false
    @State private var isLoggedOut = false
    @State private var isShowingHome = false
    let customColor = Color(red: 0.286, green: 0.3686, blue: 0.3412)
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: Home().navigationBarBackButtonHidden(true), isActive: $isShowingHome) { }
            NavigationLink(destination: Onboarding().navigationBarBackButtonHidden(true), isActive: $isLoggedOut) { }
            ScrollView {
                VStack(spacing: 20) {
                    Text("Personal Information")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Avatar")
                            .font(.subheadline)
                            .padding(.trailing, 20)
                            .foregroundStyle(.gray)
                        HStack(spacing: 10) {
                            Image(uiImage: avatarImage ?? UIImage(named: "Profile")!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            
                            
                            Button("Change") {
                                showingImagePicker = true
                                
                            }
                            .padding()
                            .background(customColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Button("Remove") {
                                avatarImage = UIImage(systemName: "person.circle")
                                
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: self.$avatarImage)
                    }
                    
                    VStack(spacing: 5) {
                        VStack(alignment: .leading, spacing: 1){
                            Section(header: Text("First name").font(.subheadline).foregroundStyle(.gray)) {
                                
                                TextField("First Name", text: $firstName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Section(header: Text("Last name").font(.subheadline).foregroundStyle(.gray)){
                                TextField("Last Name", text: $lastName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Section(header: Text("Email").font(.subheadline).foregroundStyle(.gray)) {
                                TextField("Email", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Section(header: Text("Phone number").font(.subheadline).foregroundStyle(.gray)) {
                                TextField("Phone number", text: $phoneNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.phonePad)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email Notifications")
                                .font(.headline)
                                .padding(.vertical, 5)
                            
                            HStack {
                                Toggle("Order status", isOn: $orderStatus)
                                Spacer() // Pushes the toggle to the left
                            }
                            HStack {
                                Toggle("Password changes", isOn: $passwordChanges)
                                Spacer() // Pushes the toggle to the left
                            }
                            HStack {
                                Toggle("Special offers", isOn: $specialOffers)
                                Spacer() // Pushes the toggle to the left
                            }
                            HStack {
                                Toggle("Newsletter", isOn: $newsletter)
                                Spacer() // Pushes the toggle to the left
                            }
                        }
                        .padding()
                        
                        .toggleStyle(iOSCheckboxToggleStyle())
                        .foregroundStyle(.black)
                        
                        Spacer()
                        Button("Logout", action: {
                            UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                            isLoggedOut.toggle()
                        })   .padding()
                            .frame(width: 300 , height: 50)
                            .font(.headline)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        HStack{
                            Button("Discard Changes", action: {
                                
                            })
                            .padding()
                            .foregroundColor(customColor)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .stroke(customColor)
                                
                            )
                            
                            Button("Save Changes", action: saveToUserDefaults)
                                .padding()
                                .background(customColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                    }
                    .padding()
                    
                }
                
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 40)
                        .padding(.horizontal, 75)
                }
            }
        }
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(firstName, forKey: "first_name_key")
        UserDefaults.standard.set(lastName, forKey: "last_name_key")
        UserDefaults.standard.set(email, forKey: "email_key")
        UserDefaults.standard.set(phoneNumber, forKey: "phone_number_key")
     
        UserDefaults.standard.set(orderStatus, forKey: "orderStatus")
        UserDefaults.standard.set(passwordChanges, forKey: "passwordChanges")
        UserDefaults.standard.set(specialOffers, forKey: "specialOffers")
        UserDefaults.standard.set(newsletter, forKey: "newsletter")
    }
    
}


// MARK: - Toggle styling
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
 
        Button(action: {
            
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .green : .gray)
                
                configuration.label
            }
        })
    }
}
// MARK: - Image picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                saveImage(image: image)
                
            }
            picker.dismiss(animated: true)
        }
    }
}
// MARK: - Helper Functions
func saveImage(image: UIImage) {
    if let imageData = image.jpegData(compressionQuality: 1.0) {
        UserDefaults.standard.set(imageData, forKey: "savedImage")
    }
}

func loadImage() -> UIImage? {
    if let imageData = UserDefaults.standard.data(forKey: "savedImage") {
        print("image here")
        return UIImage(data: imageData)
    }
    return nil
}
#Preview {
    UserProfile()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

}
