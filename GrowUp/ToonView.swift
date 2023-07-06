//
//  ToonView.swift
//  GrowUp
//
//  Created by Nicode . on 2023/07/07.
//

import SwiftUI
import FirebaseStorage

struct ImageWrapper: Identifiable {
    let id = UUID()
    let image: Image
    let index: Int
}

struct ToonView: View {
    @State private var toonTitle :String
    @State private var cut_count :String
    @State private var episode :String
    @State private var imageWrappers = [ImageWrapper]()
    
    init(toonTitle:String, episode:String, cut_count: String) {
        self.toonTitle = toonTitle
        self.episode = episode
        self.cut_count = cut_count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(imageWrappers.sorted(by: { $0.index < $1.index })) { imageWrapper in
                    imageWrapper.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if imageWrappers.isEmpty {
                loadImageFromServer()
            }
        }
    }
    
    private func loadImageFromServer() {
        let storage = Storage.storage()
        let gsReference = storage.reference(forURL : "gs://growup-999a1.appspot.com/\(toonTitle)/\(episode)/")
        let counting = Int(cut_count) ?? 0
            
        for idx in 0..<counting{
            let islandRef = gsReference.child("\(String(idx)).jpg")
            islandRef.getData(maxSize: 1 * 10000 * 20000) { data, error in
                if let error = error {
                    dump(error)
                } else {
                    let image = UIImage(data: data!)
                    let img = Image(uiImage: image!)
                    let imgWrapper = ImageWrapper(image: img, index: idx)
                    self.imageWrappers.append(imgWrapper)
                }
            }
        }
        
        
//        AF.request("http://\(ip):5000/get_cut_count/\(toonTitle)/\(episode)", method: .get).responseString {
//            response in
//            if let cutCountString = response.value, let cutCount = Int(cutCountString) {
//                for number in 0..<cutCount {
//                    let imageUrl = "http://\(ip):5000/get_toon/\(toonTitle)/\(episode)/\(number)"
//                    let currentIndex = number
//
//                    AF.request(imageUrl, method: .get).validate(statusCode: 200..<500).responseData { response in
//                        if let data = response.value {
//                            if let uiImage = UIImage(data: data) {
//                                let image = Image(uiImage: uiImage)
//                                let imageWrapper = ImageWrapper(image: image, index: currentIndex)
//                                self.imageWrappers.append(imageWrapper)
//                            }
//                        } else {}
//                    }
//                }
//            } else {}
//        }
    }
}

