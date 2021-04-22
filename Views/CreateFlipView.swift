	//
	//  CreateFlipView.swift
	//  Flips
	//
	//  Created by Jordan Foster on 3/30/21.
	//
	
	import SwiftUI
	
	struct CreateFlipView: View {
		
		var tricks = Trick.allCases
		let user: UserEntity
		
		@Environment(\.managedObjectContext) var context
		@State private var imageUrl: String = ""
		@State private var description: String = "Check out my flip!"
		@State private var trick: Trick = Trick.Kickflip
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
					Picker(selection: $trick, label: Text("Trick Menu").frame(maxWidth: .infinity)) {
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
						if createAccount() {
							print("Boom! New Flip!")
							//navigate to single flip view
						} else {
							// toggle alert
						}
						print("Boom! New Flip!")
					}, label: { Text("post") })
					.frame(maxWidth: .infinity)
					.border(Color.accentColor)
					Spacer(minLength: 50)
				}
				Spacer(minLength: 50)
			}
		}
		
		func createAccount() -> Bool {
			do {
				
				let uuid: UUID = UUID()
				let datetime: String = ISO8601DateFormatter().string(from: Date())
				
				
				let flip: Flip = Flip(id: uuid.uuidString, timestamp: datetime, image: imageUrl, trick: trick.rawValue, imageDescription: description, latitude: 0.0, longitude: 0.0)
				let flipEntity: FlipEntity = flip.convertToManagedObject()
				user.addToFlips(flipEntity)
				
				try context.save()
			} catch {
				return false
			}
			
			return true
		}
		
	}
	
	struct CreateFlipView_Previews: PreviewProvider {
		static var previews: some View {
			CreateFlipView(user: FlipsDataModel.designModel.users.first!.convertToManagedObject())
		}
	}
