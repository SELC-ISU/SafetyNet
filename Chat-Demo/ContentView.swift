
//
//  ContentView.swift
//  SwiftUI Chat
//
//  Created by Nick Halavins on 6/7/19. Updated 10/11/19
//  Copyright © 2019 AntiLand. All rights reserved.
//
import SwiftUI

// let's create a structure that will represent each message in chat
struct ChatMessage : Hashable {
    var message: String
    var color: Color = Color.green
    var name: String
    var isMe: Bool = false
}


//struct ChatRoom : View {
//
//}

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

struct ContentView : View {
    
     // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    @State var chatroom: String = "General Chatroom"
    
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
        }
    }
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, color: .green, name: "C", isMe: true))
        composedMessage = ""
    }
    func changeChatroom(){
        print(chatroom)
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
