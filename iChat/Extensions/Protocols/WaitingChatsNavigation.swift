//
//  WaitingChatsNavigation.swift
//  iChat
//
//  Created by Андрей Русин on 18.08.2022.
//

import UIKit
protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func makeChatActive(chat: MChat)
}
