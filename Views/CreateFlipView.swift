	//
	//  CreateFlipView.swift
	//  Flips
	//
	//  Created by Jordan Foster on 3/30/21.
	//
	
	import SwiftUI
	
	struct CreateFlipView: View {
		
		let user: UserEntity
		var tricks = Trick.allCases
		@State private var newFlip: FlipEntity?
		
		@Environment(\.managedObjectContext) var context
		@State private var imageUrl: String = ""
		@State private var description: String = "Check out my flip!"
		@State private var trick: Trick = Trick.Kickflip
		@State private var latitude: String = ""
		@State private var longitude: String = ""
		@State private var flipWasCreated: Bool = false
		@State private var alertIsPresented: Bool = false
		
		var body: some View {
			
			VStack(alignment: .center) {
				
				if !flipWasCreated {
					Spacer()
						.frame(maxHeight: 50)
					Text("Post a Flip")
						.font(.title)
					
					Spacer(minLength: 10)
					HStack {
						Spacer(minLength: 50)
						TextField("Image URL", text: $imageUrl)
							.keyboardType(.URL)
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
						TextField("Latitude", text: $latitude)
							.keyboardType(.decimalPad)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.border(Color.accentColor)
						Spacer(minLength: 50)
					}
					HStack {
						Spacer(minLength: 50)
						TextField("Longitude", text: $longitude)
							.keyboardType(.decimalPad)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.border(Color.accentColor)
						Spacer(minLength: 50)
					}
					HStack {
						Spacer(minLength: 50)
						Button(action: {
							// Create Flip
							if createFlip() {
								print("Boom! New Flip!")
								//navigate to single flip view
								flipWasCreated.toggle()
							} else {
								self.alertIsPresented.toggle()
							}
							print("Boom! New Flip!")
						}, label: { Text("post") })
						.frame(maxWidth: .infinity)
						.border(Color.accentColor)
						.alert(isPresented: $alertIsPresented) {
							Alert(
								title: Text("Flip Creation Was Unsuccessful"),
								message: Text("Try typing in your Flip information again.")
							)
						}
						Spacer(minLength: 50)
					}
					Spacer(minLength: 50)
				} else {
					FlipView(flip: newFlip!)
						.animation(.spring())
						.transition(.slide)
						.onDisappear {
							clearInformation()
						}
				}
			}
		}
		
		func createFlip() -> Bool {
			do {
				
				let uuid: UUID = UUID()
				let datetime: String = ISO8601DateFormatter().string(from: Date())
				
				// Convert String to Double
				// source: stackoverflow.com/questions/24031621/swift-how-to-convert-string-to-double
				let flip: Flip = Flip(id: uuid.uuidString, timestamp: datetime, image: imageUrl, trick: trick.rawValue, imageDescription: description, latitude: Double(latitude), longitude: Double(longitude))
				self.newFlip = flip.convertToManagedObject()
				user.addToFlips(newFlip!)
				
				try context.save()
			} catch {
				return false
			}
			
			return true
		}
		
		func clearInformation() {
			
			imageUrl = ""
			description = "Check out my flip!"
			trick = Trick.Kickflip
			latitude = ""
			longitude = ""
			flipWasCreated = false
			
		}
	}
	
	struct CreateFlipView_Previews: PreviewProvider {
		static var previews: some View {
			CreateFlipView(user: FlipsDataModel.designModel.users.first!.convertToManagedObject())
		}
	}
