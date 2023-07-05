import SwiftUI
import Alamofire
import Foundation

//var ip = "1.246.132.67"
var ip = "127.0.0.1"
var dictionary: [String: String] = ["lookism": "외모지상주의", "tower_of_god": "신의탑", "kim_director": "김부장","fight_self_taught" : "싸움독학" ]

struct ContentView: View {
    let coloredNavAppearance = UINavigationBarAppearance()
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
                        NavigationLink(destination:episodeView(toonTitle:"lookism")){
                            HStack{
                                Image("lookism").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("외모지상주의").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if date.isEmpty {
                                        Text("loading...")
                                    } else {Text(date[0]).font(.system(size:20))}
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:episodeView(toonTitle:"tower_of_god")){
                            HStack{
                                Image("tower_of_god").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("신의탑").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if date.isEmpty {
                                        Text("loading...")
                                    } else {Text(date[1]).font(.system(size:20))}
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:episodeView(toonTitle:"kim_director")){
                            HStack{
                                Image("kim_director").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("김부장").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if date.isEmpty {
                                        Text("loading...")
                                    } else {Text(date[2]).font(.system(size:20))}
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                        NavigationLink(destination:episodeView(toonTitle: "fight_self_taught")){
                            HStack{
                                Image("fight_self_taught").resizable().frame(width: 120, height: 170)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("싸움독학").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    if date.isEmpty {
                                        Text("loading...")
                                    } else {Text(date[3]).font(.system(size:20))}
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                        Spacer().frame(height: 10)
                    }.listStyle(.plain).listRowInsets(EdgeInsets()).scrollIndicators(.hidden)
                }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
            }.frame(maxWidth: .infinity).background(.red).tabItem{Label("Home",systemImage: "house.fill")}.tag(0)
            
            ImageSlide().tabItem{Image(systemName: "gearshape")
                Text("Setting")}.tag(1)
        }.accentColor(.purple).onAppear {
            UITabBar.appearance().backgroundColor = .clear
        }.onAppear{
            loadUpdateTime()
        }
    }
    
    private func loadUpdateTime() {
        AF.request("http://\(ip):5000/get_recent_update").responseDecodable(of: [String].self) { [self] response in
            switch response.result {
            case .success:
                if let arrays = response.value {
                    self.date = arrays
                }else{}
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


struct ImageWrapper: Identifiable {
    let id = UUID()
    let image: Image
    let index: Int
}

struct EpisodeWrapper:Identifiable{
    let id = UUID()
    let episode:String
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

struct episodeView : View {
    @Environment(\.colorScheme) var colorScheme
    @State private var toonTitle :String
    @State private var episodeList = [EpisodeWrapper]()
    
    init(toonTitle: String) {
        self._toonTitle = State(initialValue: toonTitle)
    }
    
    var body : some View {
        Text(dictionary[toonTitle] ?? "error").font(.system(size:50)).frame(maxHeight: 150)
        Divider().background(Color.black).padding(.horizontal).frame(height: 10)
        ScrollView{
            VStack(alignment: .center, spacing: 0){
                ForEach(episodeList.sorted{(wrapper1, wrapper2) -> Bool in
                    guard let episode1 = Int(wrapper1.episode),
                          let episode2 = Int(wrapper2.episode) else { return false }
                    return episode1 > episode2
                }){
                    epiWrapper in
                    NavigationLink(destination: ToonView(toonTitle: toonTitle, episode: epiWrapper.episode)) {
                        Text(epiWrapper.episode + " 화")
                            .font(.system(size:40))
                            .frame(maxWidth: 300)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Divider().background(Color.black).padding(.horizontal).frame(height: 10)
                }
            }
        }.onAppear{
            episodeList.removeAll()
            loadEpisodes()
        }
    }
    
    private func loadEpisodes(){
        AF.request("http://\(ip):5000/get_episode_count/\(toonTitle)", method: .get).responseString{
            response in
            if let result = response.value?.split(separator: ":"){
                if let startValue = Int(result[0]), let offsetValue = Int(result[1]) {
                    let start = startValue
                    let offset = offsetValue
                    for idx in start..<start + offset {
                        self.episodeList.append(EpisodeWrapper(episode: String(idx)))
                    }
                } else {}
            }else{}
        }
    }
}

struct ToonView: View {
    @State private var toonTitle :String
    @State private var episode :String
    @State private var imageWrappers = [ImageWrapper]()
    
    init(toonTitle: String, episode: String) {
        self.toonTitle = toonTitle
        self.episode = episode
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
        AF.request("http://\(ip):5000/get_cut_count/\(toonTitle)/\(episode)", method: .get).responseString {
            response in
            if let cutCountString = response.value, let cutCount = Int(cutCountString) {
                for number in 0..<cutCount {
                    let imageUrl = "http://\(ip):5000/get_toon/\(toonTitle)/\(episode)/\(number)"
                    let currentIndex = number
                    
                    AF.request(imageUrl, method: .get).validate(statusCode: 200..<500).responseData { response in
                        if let data = response.value {
                            if let uiImage = UIImage(data: data) {
                                let image = Image(uiImage: uiImage)
                                let imageWrapper = ImageWrapper(image: image, index: currentIndex)
                                self.imageWrappers.append(imageWrapper)
                            }
                        } else {}
                    }
                }
            } else {}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
