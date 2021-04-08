	//
	//  CreateFlipView.swift
	//  Flips
	//
	//  Created by Jordan Foster on 3/30/21.
	//
	
	import SwiftUI
	
	struct CreateFlipView: View {
		
		@Environment(\.managedObjectContext) var context
		var tricks = Trick.allCases
		@State private var imageUrl: String = ""
		@State private var description: String = "Check out my flip!"
		@State private var trick: String = ""
		@State private var geolocation: String = ""
		
		var body: some View {
			
			VStack(alignment: .center) {
				Spacer()
					.frame(maxHeight: 50)
				Text("Post a Flip")
					.font(.title)
				
				Spacer(minLength: 10)
				HStack {
					Spacer(minLength: 50)
					TextField("Image URL", text: $imageUrl)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					TextEditor(text: $description)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
						.frame(maxHeight: 100)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Trick Menu").frame(maxWidth: .infinity)) {
						ForEach(tricks, id: \.self) { Text($0.rawValue) }
					}
					.pickerStyle(MenuPickerStyle())
					.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					TextField("Geolocation", text: $geolocation)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				HStack {
					Spacer(minLength: 50)
					Button(action: {
						// Create Flip
						print("Boom! New Flip!")
					}, label: { Text("post") })
					.frame(maxWidth: .infinity)
					.border(Color.accentColor)
					.disabled(true) // TODO:
					Spacer(minLength: 50)
				}
				Spacer(minLength: 50)
			}
		}
	}
	
	struct CreateFlipView_Previews: PreviewProvider {
		static var previews: some View {
			CreateFlipView()
		}
	}
