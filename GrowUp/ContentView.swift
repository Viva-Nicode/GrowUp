import SwiftUI
import Alamofire
import Foundation
import Firebase

var dictionary: [String: String] = ["lookism": "외모지상주의", "tower_of_god": "신의탑", "kim_director": "김부장","fight_self_taught" : "싸움독학" ]

struct ContentView: View {
    let navigationBarAppearance = UINavigationBarAppearance()
    @State private var updateDic = Dictionary<String, Any>()
    @State private var date: [String] = []
    
//    Image(systemName: "chevron.backward")
    init() {
        navigationBarAppearance.backgroundColor = UIColor.clear
        navigationBarAppearance.shadowColor = .clear
//        coloredNavAppearance.configureWithOpaqueBackground()
//        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        TabView{
            NavigationView {
                VStack {
                    VStack{
                        Text("Grow Up").font(.system(size: 45))
                        Spacer().frame(height: 10)
                        Text("Created by Nicode").font(.system(size: 20))
                    }.frame(height: 180).background(Color.clear)
                    
                    List{
                        ForEach(dictionary.sorted(by: <), id: \.key) { key, value in
                            NavigationLink(destination:EpisodeView(toonTitle:key)){
                                HStack{
                                    Image(key).resizable().frame(width: 90, height: 140).cornerRadius(20)
                                    Spacer().frame(width: 50)
                                    VStack(alignment:.leading){
                                        Text(value).font(.system(size:30))
                                        Spacer().frame(height:20)
                                        if updateDic.isEmpty {
                                            Text("loading...").background(.clear)
                                        } else {
                                            if let stringValue = updateDic[key] as? String {
                                                Text(stringValue).font(.system(size:20))
                                            }
                                        }
                                    }.frame(minWidth: 100)
                                }.listRowInsets(EdgeInsets())
                            }
                        }
                    }.listStyle(.insetGrouped).listRowInsets(EdgeInsets()).scrollIndicators(.hidden).cornerRadius(28).padding(.bottom, 10)
                }.background(LinearGradient(gradient: Gradient(colors:
                                                                [Color(red: 77/255, green: 113/255, blue: 167/255),
                                                                 Color(red:242/255, green:196/255, blue: 232/255)]),
                                            startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            .frame(maxWidth: .infinity).tabItem{Label("Home",systemImage: "house.fill")}.tag(0)
            ImageSlide().tabItem{Image(systemName: "gearshape")
                Text("Setting")}.tag(1)
        }.edgesIgnoringSafeArea(.all)
        .accentColor(.orange).onAppear{
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
