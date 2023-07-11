//
//  EpisodeView.swift
//  GrowUp
//
//  Created by Nicode . on 2023/07/07.
//

import SwiftUI
import Firebase

struct EpisodeWrapper:Identifiable{
    let id = UUID()
    let episode:String
    let cut_count:String
}

struct EpisodeView: View {
    @State private var toonTitle :String
    @State private var episodeList = [EpisodeWrapper]()
    @State private var isExtension = false
    
    init(toonTitle: String) {
        self._toonTitle = State(initialValue: toonTitle)
    }
    
    var body : some View {
        ZStack(alignment: .center){
            VStack() {
                Spacer()
                Rectangle()
                    .fill(Color(red:243/255, green: 243/255, blue: 248/255))
                    .frame(height: 620).padding(.bottom,-60)
            }
            
            VStack{
                Image(toonTitle+"-epi").resizable()
                    .frame(width: 370, height: 260).cornerRadius(15)
                    .padding(.top, 100).ignoresSafeArea().padding(.bottom, -80)
                
                List{
                    ForEach(episodeList.sorted{(wrapper1, wrapper2) -> Bool in
                        guard let episode1 = Int(wrapper1.episode),
                              let episode2 = Int(wrapper2.episode) else { return false }
                        return episode1 > episode2
                    }){
                        epiWrapper in
                        NavigationLink(destination: ToonView(toonTitle: toonTitle,
                                                             episode:epiWrapper.episode,
                                                             cut_count: epiWrapper.cut_count)) {
                            Text(epiWrapper.episode + "화")
                                .font(.system(size:25))
                                .foregroundColor(.black)
                        }
                    }
                }.frame(width: 400).onAppear{
                    episodeList.removeAll()
                    loadEpisodes()
                }
            }
        }.background(
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 77/255, green: 113/255, blue: 167/255),
                                                 Color(red:242/255, green:196/255, blue: 232/255)]),
                           startPoint: .top, endPoint: .bottom))
    }
    
    private func loadEpisodes(){
        
        let db = Firestore.firestore()
        let docRef = db.collection("toons").document(toonTitle)
        
        docRef.getDocument(){ (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    for idx in 0..<data.count{
                        let res = data[String(idx)] ?? "-1:0"
                        if let stringRes = res as? String {
                            let spl = stringRes.split(separator: ":")
                            self.episodeList.append(EpisodeWrapper(episode: String(spl[0]), cut_count: String(spl[1])))
                        } else {}
                    }
                }
            }
        }
        //        AF.request("http://\(ip):5000/get_episode_count/\(toonTitle)", method: .get).responseString{
        //            response in
        //            if let result = response.value?.split(separator: ":"){
        //                if let startValue = Int(result[0]), let offsetValue = Int(result[1]) {
        //                    let start = startValue
        //                    let offset = offsetValue
        //                    for idx in start..<start + offset {
        //                        self.episodeList.append(EpisodeWrapper(episode: String(idx)))
        //                    }
        //                } else {}
        //            }else{}
        //        }
    }
}
struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(toonTitle: "lookism")
    }
}
