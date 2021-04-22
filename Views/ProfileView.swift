//
//  ProfileView.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import SwiftUI



struct ProfileView: View {
	
	var user: UserEntity
	
	var body: some View {
		
		let myFlips = Array(user.flips as! Set<FlipEntity>)
		
		VStack {
			AsyncImage(
				url: user.profileImage!,
				placeholder: { Text("...") },
				image: { Image(uiImage: $0).resizable() }
			)
			.aspectRatio(contentMode: .fit)
			.clipShape(Circle())
			.frame(width: 175, height: 175)
			Text("\(user.username!)")
				.font(.largeTitle)
			Text("\(user.bio ?? "")")
				.font(.headline)
			Spacer()
			Form {
				HStack {
					Text("Name:")
					Spacer()
					Text(user.name!)
				}
				HStack {
					Text("Email:")
					Spacer()
					Text(user.email!)
				}
				HStack {
					Text("Location:")
					Spacer()
					Text("\(user.city ?? ""), \(user.state ?? "")")
				}
			}
			Spacer()
			Text("Flips")
				.font(.title)
			
			ScrollView(.horizontal) {
				HStack {
					ForEach(myFlips, id: \.self) { flip in
						
						AsyncImage(
							url: flip.image!,
							placeholder: { Text("...") },
							image: { Image(uiImage: $0).resizable() }
						)
						.aspectRatio(contentMode: .fit)
						.frame(width: 100, height: 100)
						.clipShape(Rectangle())
					}
				}
			}
			Spacer()
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(user: FlipsDataModel.designModel.users.first!.convertToManagedObject())
	}
}
