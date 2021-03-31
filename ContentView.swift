//
//  ContentView.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@State private var selection = 1
	@State var model: FlipsModel
	
	var body: some View {
		CoreDataView(selection: selection, model: $model)
	}
}

struct CoreDataView: View {
	
	@State var selection = 1
	@Binding var model: FlipsModel
	@Environment(\.managedObjectContext) var context
	
	@FetchRequest(
		entity: UserEntity.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \UserEntity.id, ascending: true),
	]) var users: FetchedResults<UserEntity>

	@FetchRequest(
		entity: FlipEntity.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \FlipEntity.id, ascending: true),
	]) var flips: FetchedResults<FlipEntity>

	@FetchRequest(
		entity: RatingEntity.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \RatingEntity.id, ascending: true),
	]) var ratings: FetchedResults<RatingEntity>
	
	@FetchRequest(entity: FeedbackEntity.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \FeedbackEntity.id, ascending: true),
	]) var feedbacks: FetchedResults<FeedbackEntity>
	
	init(selection: Int, model: Binding<FlipsModel>) {
		
		_model = model
		self.selection = selection
		
	}
	
	var body: some View {
			TabView(selection: $selection) {
				HomeView()
					.tabItem { Image(systemName: "home") }
					.tag(1)
					.preferredColorScheme(.dark)
				FlipsView(flips: flips.map{ Flip(flipEntity: $0) })
					.tabItem { Image(systemName: "bandage") }
					.tag(2)
					.preferredColorScheme(.dark)
				CreateFlipView()
					.tabItem { Image(systemName: "plus.circle.fill").renderingMode(.original) }
					.tag(3)
					.preferredColorScheme(.dark)
				ContactUsView()
					.tabItem { Image(systemName: "questionmark.circle") }
					.tag(4)
					.preferredColorScheme(.dark)
				ProfileView()
					.tabItem { Image(systemName: "person.crop.square.fill") }
					.tag(5)
					.preferredColorScheme(.dark)
			}
		}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
			ContentView(model: FlipsDataModel.designModel)
				.preferredColorScheme(.dark)
    }
}
