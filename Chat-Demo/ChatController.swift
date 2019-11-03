import Combine
import SwiftUI

class ChatController : ObservableObject{
//  to remind us to update swiftui
    var hasChanged = PassthroughSubject<Void, Never>()
    
    @Published var messages = [
        ChatMessage(message: "Hello world", color: .red,  name: "A"),
    ]
    
    func sendMessage(_ chatMessage: ChatMessage){
        messages.append(chatMessage)
        hasChanged.send()
    }
    
}
