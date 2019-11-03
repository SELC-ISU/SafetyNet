import Combine
import SwiftUI

class ChatController : ObservableObject{
//  to remind us to update swiftui
    var hasChanged = PassthroughSubject<Void, Never>()
    let hermes = Hermes()
    
    @Published var messages = [
        ChatMessage(message: "", name: "", messageID: generateMessageID() ),
    ]
    
    func sendMessage(_ chatMessage: ChatMessage){
        
        let id = generateMessageID()
        var json = "{\"messageID\":" + String(id)
        json += ", \"messageData\": \"" + chatMessage.message + "\""
        json += ", \"name\": \"" + "CHANGEME" + "\""
        json += ",\"flag\": \"00000\"}"
        
        print(json)
        self.messages.append(chatMessage)
        hermes.send(message: json)
        
        
        hasChanged.send()
    }
    
    func receiveMessage(manager: Hermes, JSONMessage: String){
        OperationQueue.main.addOperation {
            let message = self.decodeJSON(colorString: JSONMessage)
            let my_chat_msg = ChatMessage(message: message!.messageData, color: .gray, name: "A", isMe: false, messageID: message!.messageID)
//            if you have not already recieved the message, send it out again
            if(!self.contains(message: my_chat_msg)){
                self.hermes.send(message: JSONMessage)
                self.messages.append(my_chat_msg)
            }

            
        }
    }
    
    func decodeJSON(colorString: String) -> Message? {
        //Decode
        guard let data = colorString.data(using: String.Encoding.utf8) else { fatalError("☠️") }
        do {
            let newMessage = try JSONDecoder().decode(Message.self, from: data)
            print(newMessage)
            return newMessage
        } catch {
            print(error)
        }
        return nil
    }
    
    func contains(message : ChatMessage) -> Bool{
        for object in self.messages {
            if object.messageID == message.messageID{
                return true
            }
        }
        return false
    }
    
    
}
