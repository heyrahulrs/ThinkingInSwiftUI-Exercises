//
//  ContentView.swift
//  TiS-Chapter2
//
//  Created by Rahul Sharma on 18/05/22.
//

import SwiftUI

var url = URL(string: "https://picsum.photos/v2/list")!

struct Photo: Identifiable, Codable {
    var id: String
    var author: String
    var width, height: Int
    var url: String
    var download_url: String
}

struct ContentView: View {
    
    @State var photos: [Photo] = []
    
    var body: some View {
        if photos.isEmpty {
            ProgressView()
                .task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        self.photos = photos
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
        } else {
            NavigationView {
                List(photos) { photo in
                    NavigationLink {
                        PhotoDetailView(photo: photo)
                    } label: {
                        Text(photo.author)
                    }
                }
                .navigationTitle(Text("Photos"))
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
