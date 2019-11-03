//
//  ChatRoomController.swift
//  Chat-Demo
//
//  Created by Ann Gould on 11/2/19.
//  Copyright © 2019 Ann Gould. All rights reserved.
//

import SwiftUI
import Combine

class ChatRoomController : ObservableObject{
//  to remind us to update swiftui
    var hasChanged = PassthroughSubject<Void, Never>()

    
    func changeChatroom(_ chatRoom: String){
//      logic for changing chatroom here
        print(chatRoom)
    }
}

