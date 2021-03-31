//
//  LoadingView.swift
//  Flips
//
//  Created by Jordan Foster on 3/17/21.
//

import SwiftUI

struct LoadingView: View {
  
	@Binding private var networkDataLoaded: Bool
	
	init(model: FlipsCoreDataModel, networkDataLoaded: Binding<Bool>) {
		_networkDataLoaded = networkDataLoaded
		let dataModel = FlipsCoreDataModel()
		dataModel.loadAllDatabaseData(isLoaded: networkDataLoaded)
	}
	
	var body: some View {
		VStack {
			ProgressView()
		}
	}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
			LoadingView(model: FlipsCoreDataModel(), networkDataLoaded: .constant(false))
				.preferredColorScheme(.dark)
    }
}
