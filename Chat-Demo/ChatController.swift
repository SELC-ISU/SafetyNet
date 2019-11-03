import Combine
import SwiftUI
import RNCryptor

class ChatController : ObservableObject{
//  to remind us to update swiftui
    var hasChanged = PassthroughSubject<Void, Never>()
    let hermes = Hermes()
    
    var i_love_warnings = ""
    
    @Published var messages = [
        ChatMessage(message: "", name: "", messageID: generateMessageID() ),
    ]
    
    var stupid = [555]
    func sendMessage(_ chatMessage: ChatMessage){
        if(chatMessage.room != i_love_warnings){
            self.messages = []
            i_love_warnings = chatMessage.room
        }
        let id = generateMessageID()
        let encrypted_message = try? encryptMessage(message: chatMessage.message, encryptionKey: chatMessage.room)
        let encrypted_flag = try? encryptMessage(message: "00000", encryptionKey: chatMessage.room)
        
        var json = "{\"messageID\":" + String(id)
        json += ", \"messageData\": \"" + encrypted_message! + "\""
        json += ", \"name\": \"" + "CHANGEME" + "\""
        json += ",\"flag\": \"" + encrypted_flag! + "\"}"
        
        print(json)
        self.messages.append(chatMessage)
        self.stupid.append(id)
        hermes.send(message: json)
        
        
        hasChanged.send()
    }
    
    func receiveMessage(manager: Hermes, JSONMessage: String, chatroom: String){
        OperationQueue.main.addOperation {
            
            let message = self.decodeJSON(colorString: JSONMessage)
            let message_data = try? decryptMessage(encryptedMessage: message!.messageData, encryptionKey: chatroom)
            let zeros = try? decryptMessage(encryptedMessage: message!.flag, encryptionKey: chatroom)
            
            
            var my_chat_msg = ChatMessage(message: "", color: .gray, name: "A", isMe: false, messageID: message!.messageID)
//            if you have not already recieved the message, send it out again
            if(!self.contains(message: my_chat_msg) && !self.stupid.contains(message!.messageID)){
                self.stupid.append(message!.messageID)
                
                
                if(zeros == "00000"){
                    my_chat_msg = ChatMessage(message: message_data!, color: .gray, name: "A", isMe: false, messageID: message!.messageID)
                    self.messages.append(my_chat_msg)
                }
                self.hermes.send(message: JSONMessage)
                    
                
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

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
    return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

func encryptMessage(message: String, encryptionKey: String) throws -> String {
    let messageData = message.data(using: .utf8)!
    let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
    return cipherData.base64EncodedString()
}


func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {

    let encryptedData = Data.init(base64Encoded: encryptedMessage)!
    let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
    let decryptedString = String(data: decryptedData, encoding: .utf8)!

    return decryptedString
}
