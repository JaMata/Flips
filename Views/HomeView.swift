//
//  HomeView.swift
//  Flips
//
//  Created by Jordan Foster on 3/19/21.
//

import SwiftUI

struct HomeView: View {
	
	var flips: [Flip]
	
	var body: some View {
		
		NavigationView {
			
			List(Trick.allCases, id: \.self) { trick in
				NavigationLink(destination: FlipsView(flips: flips, filter: trick.rawValue), label: {
					Text("\(trick.rawValue)s")
				})
			}.navigationBarTitle("Flips by Trick")
		}
		/*
		VStack(alignment: .leading) {
			ForEach(Trick.allCases, id: \.self) {
				
				HStack {
					Text("\($0.rawValue)")
						.font(.title2)
						.padding(.trailing)
					Spacer()
				}
			}
		}
		*/
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(flips: FlipsDataModel.designModel.flips)
	}
}
