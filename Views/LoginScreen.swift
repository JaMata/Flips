//
//  LoginScreen.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import SwiftUI

struct LoginScreen: View {
	
	@State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
	@State private var password: String = ""
	@EnvironmentObject var userAuth: UserAuth
	@State private var networkDataLoaded: Bool = false
	@State private var isSignupShowing: Bool = false
	
	var body: some View {
		
		if !userAuth.isLoggedIn {
			return AnyView(VStack {
				Spacer()
					.frame(maxHeight: 50)
				HStack {
					Image("flips")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30.0, height: 30.0)
					Text("Flips")
						.font(.largeTitle)
				}

				Spacer(minLength: 10)
				VStack(alignment: .center) {
					HStack {
						Spacer(minLength: 50)
						TextField("Username", text: $username)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.border(Color.accentColor)
						Spacer(minLength: 50)
					}
					HStack {
						Spacer(minLength: 50)
						SecureField("Password", text: $password)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.border(Color.accentColor)
						Spacer(minLength: 50)
					}
					HStack {
						Spacer(minLength: 50)
						Button(action: {
							self.saveUserName(userName: self.username)
							self.userAuth.login()
						}, label: { Text("login") })
							.frame(maxWidth: .infinity)
						.border(Color.accentColor)
						Spacer(minLength: 50)
					}
				}
				Button("...or create an account", action: { self.isSignupShowing.toggle() })
					.padding()
					.sheet(isPresented: $isSignupShowing, content: {
						NavigationView {
							SignupScreen(isSignupShowing: $isSignupShowing)
								.navigationBarTitle("sign up")
								.navigationBarItems(leading: Button("cancel") {
									self.isSignupShowing.toggle()
								})
						}
					})
				Spacer(minLength: 50)
				Text("Flips, Inc. 2021")
			}.background(
				Image("login-bg")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.opacity(0.6)
					.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			))
		} else {
			let dataModel = FlipsCoreDataModel()
			if networkDataLoaded == false {
				return AnyView(LoadingView(model: dataModel, networkDataLoaded: $networkDataLoaded))
			}
			else {
				return AnyView(ContentView(model: dataModel))
			}
		}
	}

	func saveUserName(userName: String) {
		UserDefaults.standard.set(userName.lowercased(), forKey: "username")
		
	}

}

struct LoginScreen_Previews: PreviewProvider {
	static var previews: some View {
		LoginScreen()
			.preferredColorScheme(.dark)
			.environmentObject(UserAuth())
	}
}
