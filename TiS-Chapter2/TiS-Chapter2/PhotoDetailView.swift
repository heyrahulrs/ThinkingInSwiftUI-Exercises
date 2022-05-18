//
//  PhotoDetailView.swift
//  TiS-Chapter2
//
//  Created by Rahul Sharma on 18/05/22.
//

import SwiftUI

class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func loadImage(_ photo: Photo) async {
        print("Loading image with url: \(photo.url)")
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: photo.download_url)!)
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.sync {
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct PhotoDetailView: View {
    
    @StateObject var imageLoader = ImageLoader()
    var photo: Photo
    
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Rectangle()
                .fill(Color.black.opacity(0.05))
                .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                .overlay {
                    ProgressView()
                }
                .task {
                    await imageLoader.loadImage(photo)
                }
        }
    }
    
}

//struct PhotoDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoDetailView(photo: Photo(id: "", author: "", width: 3000, height: 4000, url: "", download_url: ""))
//    }
//}
