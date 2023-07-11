//
//  ImageSlide.swift
//  GrowUp
//
//  Created by Nicode . on 2023/07/07.
//

import SwiftUI

struct ImageSlide: View {
    private let images = ["slide_1", "slide_2", "slide_3", "slide_4", "slide_5", "slide_6"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                ZStack{
                    Image(item).resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.top)
                    Text("Have a nice day").font(.system(size:30))
                        .frame(maxWidth: 250, maxHeight: 110, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.780, green: 1.0, blue: 0.973), Color(red: 1.0, green: 0.800, blue: 0.914)]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(30).foregroundColor(Color(red: 158/255, green: 179/255, blue: 1))
                }
            }
        }
        .tabViewStyle(PageTabViewStyle()).edgesIgnoringSafeArea(.top)
        .onAppear {
            setupAppearance()
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .white
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.4)
    }
}

struct ImageSlide_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlide()
    }
}
