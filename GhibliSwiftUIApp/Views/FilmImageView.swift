//
//  FilmImageView.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import SwiftUI

struct FilmImageView: View {
    
    let url: URL?
    
    init(urlPath: String) {
        self.url = URL(string: urlPath)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
                case .empty:
                    Color(white: 0.8)
                        .overlay {
                            ProgressView()
                                .controlSize(.large)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                case .failure(_):
                    Text("Could not get image")
                @unknown default:
                    fatalError()
            }
        }
       
    }
}

#Preview("poster image") {
     FilmImageView(url: URL.convertAssetImage(named: "posterImage"))
        .frame(height: 150)
}

#Preview("banner image") {
    
    let name = "bannerImage"
    let url = URL.convertAssetImage(named: name)
    
   // FilmImageView(urlPath: "https://image.tmdb.org/t/p/w533_and_h300_bestv2/3cyjYtLWCBE1uvWINHFsFnE8LUK.jpg")
    FilmImageView(url: url)
        .frame(height: 300)
    
}


