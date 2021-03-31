//
//  SignupScreen.swift
//  Flips
//
//  Created by Jordan Foster on 3/18/21.
//

import SwiftUI

struct SignupScreen: View {
	
	@State private var username: String = ""
	@State private var password: String = ""
	@State private var passwordCopy: String = ""
	@State private var name: String = ""
	@State private var email: String = ""
	@State private var country: String = ""
	@Binding var isSignupShowing: Bool
	
	var body: some View {
		VStack {
			Spacer()
				.frame(maxHeight: 50)
			HStack {
				Image("flips")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 30.0, height: 30.0)
				Text("Flips")
					.font(.title)
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
					SecureField("Re-enter Password", text: $passwordCopy)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					TextField("Name", text: $name)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					TextField("Email", text: $email)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					TextField("Country", text: $country)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					Button(action: {
						// Create User
						
						self.isSignupShowing.toggle()
					}, label: { Text("sign up") })
					.frame(maxWidth: .infinity)
					.border(Color.accentColor)
					Spacer(minLength: 50)
				}
			}
			Spacer(minLength: 50)
			Text("Flips, Inc. 2021")
		}.background(
			Image("login-bg")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.opacity(0.6)
				.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
		)
	}
}

struct SignupScreen_Previews: PreviewProvider {
	static var previews: some View {
		SignupScreen(isSignupShowing: .constant(true))
			.preferredColorScheme(.dark)
	}
}
