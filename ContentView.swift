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
		sortDescriptors: [],
		predicate: NSPredicate(format: "username == %@", UserDefaults.standard.string(forKey: "username")!)
	) var user: FetchedResults<UserEntity>
	
	@FetchRequest(
		entity: FlipEntity.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \FlipEntity.timestamp, ascending: true),
	]) var flips: FetchedResults<FlipEntity>
	
	@FetchRequest(
		entity: RatingEntity.entity(),
		sortDescriptors: []) var ratings: FetchedResults<RatingEntity>
	
	@FetchRequest(entity: FeedbackEntity.entity(),
								sortDescriptors: []) var feedbacks: FetchedResults<FeedbackEntity>
	
	init(selection: Int, model: Binding<FlipsModel>) {
		
		_model = model
		self.selection = selection
		
	}
	
	var body: some View {
			TabView(selection: $selection) {
				HomeView(flips: flips.map{ $0 })
					.tabItem { Image(systemName: "house") }
					.tag(1)
					.preferredColorScheme(.dark)
				FlipsView(flips: flips.map{ $0 })
					.tabItem { Image(systemName: "bandage") }
					.tag(2)
					.preferredColorScheme(.dark)
				CreateFlipView(user: user.first!)
					.tabItem { Image(systemName: "plus.circle.fill") }
					.tag(3)
					.preferredColorScheme(.dark)
				ProfileView(user: user.first!)
					.tabItem { Image(systemName: "person.crop.circle") }
					.tag(4)
					.preferredColorScheme(.dark)
				ContactUsView()
					.tabItem { Image(systemName: "questionmark.circle") }
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
