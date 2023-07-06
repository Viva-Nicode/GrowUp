import SwiftUI
import Alamofire
import Foundation
import Firebase

var dictionary: [String: String] = ["lookism": "외모지상주의", "tower_of_god": "신의탑", "kim_director": "김부장","fight_self_taught" : "싸움독학" ]

struct ContentView: View {
    let coloredNavAppearance = UINavigationBarAppearance()
    @State private var updateDic = Dictionary<String, Any>()
    @State private var date: [String] = []
        
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.clear
        coloredNavAppearance.shadowColor = .clear
        //coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        //coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        TabView{
            NavigationView {
                VStack {
                    VStack{
                        Text("🌱🌳Grow Up🌳🌱").font(.system(size: 45))
                        Spacer().frame(height: 10)
                        Text("Created by Nicode / version 1.0.0").font(.system(size: 20))
                    }.frame(height: 180)
                    Divider().background(Color.black).padding(.horizontal).frame(height: 30)
                    List{
                        NavigationLink(destination:EpisodeView(toonTitle:"lookism")){
                            HStack{
                                Image("lookism").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("외모지상주의").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if updateDic.isEmpty {
                                        Text("loading...")
                                    } else {
                                        if let stringValue = updateDic["lookism"] as? String {
                                            Text(stringValue).font(.system(size:20))
                                        }
                                    }
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:EpisodeView(toonTitle:"tower_of_god")){
                            HStack{
                                Image("tower_of_god").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("신의탑").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if updateDic.isEmpty {
                                        Text("loading...")
                                    } else {
                                        if let stringValue = updateDic["tower_of_god"] as? String {
                                            Text(stringValue).font(.system(size:20))
                                        }
                                    }
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:EpisodeView(toonTitle:"kim_director")){
                            HStack{
                                Image("kim_director").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("김부장").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if updateDic.isEmpty {
                                        Text("loading...")
                                    } else {
                                        if let stringValue = updateDic["kim_director"] as? String {
                                            Text(stringValue).font(.system(size:20))
                                        }
                                    }
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:EpisodeView(toonTitle: "fight_self_taught")){
                            HStack{
                                Image("fight_self_taught").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("싸움독학").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if updateDic.isEmpty {
                                        Text("loading...")
                                    } else {
                                        if let stringValue = updateDic["fight_self_taught"] as? String {
                                            Text(stringValue).font(.system(size:20))
                                        }
                                    }
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                    }.listStyle(.plain).listRowInsets(EdgeInsets()).scrollIndicators(.hidden)
                }
            }.frame(maxWidth: .infinity).tabItem{Label("Home",systemImage: "house.fill")}.tag(0)
            ImageSlide().tabItem{Image(systemName: "gearshape")
                Text("Setting")}.tag(1)
        }.accentColor(.purple).onAppear{
            UITabBar.appearance().backgroundColor = .clear
        }.onAppear{
            loadUpdateTime()
        }
    }
    
    private func loadUpdateTime() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("toons").document("updateDate")
        
        docRef.getDocument(){ (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print(type(of: data))
                    self.updateDic = data
                }
            }
        }
//        AF.request("http://\(ip):5000/get_recent_update").responseDecodable(of: [String].self) { [self] response in
//            switch response.result {
//            case .success:
//                if let arrays = response.value {
//                    self.date = arrays
//                }else{}
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
    }
}

struct ImageSlide : View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
