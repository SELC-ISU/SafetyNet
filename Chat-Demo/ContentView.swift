
//
//  ContentView.swift
//  SwiftUI Chat
//
//
import SwiftUI

var all_message_ids: [Int] = []

// let's create a structure that will represent each message in chat
struct ChatMessage : Hashable {
    var message: String
    var color: Color = Color.green
    var name: String
    var isMe: Bool = false
    var room: String = "General Chatroom"
    var messageID: Int
}

struct Message: Codable {
    let messageID: Int
    let messageData: String
    let name: String
    let flag: String
}
// TODO: ADD CONNECTED DEVICES

struct ChatRow : View {
    
    var chatMessage: ChatMessage
    var body: some View {
        Group{
            if !chatMessage.isMe{
                HStack {
                    Group {
                        Text(chatMessage.name)
                        Text(chatMessage.message)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        
                    }
                }
            }
            else{
                HStack {
                    Group {
//                      spaces out
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                        Text(chatMessage.name)
                    }
                }
            }
        }
    }
}
func generateMessageID() -> Int {
    var id = 0
    var contains = true;
    
    while(contains) {
        id = Int.random(in: 0 ..< 100000)
        contains = false
        if(all_message_ids.contains(id)) {
            contains = true
        }
    }
    all_message_ids.append(id)
    return id
}

struct ContentView : View {
    
     // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    @State var chatroom: String = "General Chatroom"
    let hermes = Hermes()
    
    
    
    
    var body: some View {
      
        VStack {
            
            HStack {
                TextField("Chatroom", text: $chatroom).frame(minHeight: CGFloat(30))
            }.frame(minHeight: CGFloat(50)).padding()
            
            
            List {
                ForEach(chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }
            
            HStack {
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .onAppear {self.hermes.delegate = self } 
        }
    }
    func sendMessage() {
        print(chatroom)
//        var Id = generateMessageID()
        chatController.sendMessage(ChatMessage(message: composedMessage, name: "C", isMe: true, room: chatroom, messageID: generateMessageID()))

    }
}

extension ContentView : HermesDelegate {
    func connectedDevicesChanged(manager: Hermes, connectedDevices: [String]) {
    
    }
    
    func sendMessage(manager: Hermes, colorString: String) {
        chatController.receiveMessage(manager: manager, JSONMessage: colorString, chatroom: chatroom)
    }
    
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}
#endif
