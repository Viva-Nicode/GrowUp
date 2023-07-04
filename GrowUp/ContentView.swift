import SwiftUI
import Alamofire
import Foundation


//var ip = "1.246.132.67"
var ip = "127.0.0.1"

struct ContentView: View {
    let coloredNavAppearance = UINavigationBarAppearance()
    @State var selectedIndex = 0

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
        TabView(selection: $selectedIndex){
            NavigationView {
                VStack {
                    VStack{
                        Text("🌱🌳Grow Up🌳🌱").font(.system(size: 45))
                        Spacer().frame(height: 10)
                        Text("Created by Nicode / version 1.0.0").font(.system(size: 20))
                    }.frame(height: 180)
                    List{
                        NavigationLink(destination:episodeView()){
                            HStack{
                                Image("fight_self_taught").resizable().frame(width: 120, height: 180)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("싸움독학").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    Text("2023.6.17").font(.system(size:20))
                                }
                            }.listRowInsets(EdgeInsets())
                        }.padding(.all, -20)
                        Spacer().frame(height: 10)
                        NavigationLink(destination:ToonView(toonTitle:"kim_director")){
                            HStack{
                                Image("kim_director").resizable().frame(width: 120, height: 180)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("김부장").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    Text("2023.6.17").font(.system(size:20))
                                }
                            }.listRowInsets(EdgeInsets())
                        }.padding(.all, -20)
                        Spacer().frame(height: 10)
                        NavigationLink(destination:ToonView(toonTitle:"lookism")){
                            HStack{
                                Image("lookism").resizable().frame(width: 120, height: 180)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("외모지상주의").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    Text("2023.6.17").font(.system(size:20))
                                }
                            }.listRowInsets(EdgeInsets())
                        }.padding(.all, -20)
                        Spacer().frame(height: 10)
                        NavigationLink(destination:ToonView(toonTitle:"tower_of_god")){
                            HStack{
                                Image("tower_of_god").resizable().frame(width: 120, height: 180)
                                Spacer().frame(width: 50)
                                VStack(alignment:.leading){
                                    Text("신의탑").font(.system(size:30))
                                    Spacer().frame(height:20)
                                    Text("2023.6.17").font(.system(size:20))
                                }
                            }.listRowInsets(EdgeInsets())
                        }.padding(.all, -20)
                        Spacer().frame(height: 10)
                    }.listStyle(.plain).listRowInsets(EdgeInsets()).scrollIndicators(.hidden)
                }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
            }.frame(maxWidth: .infinity).background(.red).tabItem{Label("Home",systemImage: "house.fill")}.tag(0)
            
            Text("Setting Page").tabItem{Image(systemName: "gearshape")
                Text("Setting")}.tag(1)
        }.accentColor(.purple).onAppear {
            UITabBar.appearance().backgroundColor = .clear
        }
    }
}

struct ImageWrapper: Identifiable {
    let id = UUID()
    let image: Image
    let index: Int
}

struct episodeView : View {
    var body : some View {
        List{
            NavigationLink(destination:ToonView(toonTitle:"kim_director")){
                Text("Hello")
            }
            
            Text("Hello")
            Text("Hello")
            Text("Hello")
        }.onAppear(){
            
        }
        
    }
}

struct ToonView: View {
    @State private var toonTitle :String
    @State private var imageWrappers = [ImageWrapper]()
    
    
    init(toonTitle: String) {
        self.toonTitle = toonTitle
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
            loadImageFromServer()
        }
    }
    
    private func loadImageFromServer() {
        AF.request("http://\(ip):5000/get_cut_count/\(toonTitle)", method: .get).responseString { response in
            if let cutCountString = response.value, let cutCount = Int(cutCountString) {
                for number in 0..<cutCount {
                    let imageUrl = "http://\(ip):5000/get_toon/\(toonTitle)/\(number)"
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
