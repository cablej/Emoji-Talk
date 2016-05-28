//
//  EmojiTalkHelper.swift
//  Emoji Talk
//
//  Created by Jack Cable on 5/28/16.
//  Copyright © 2016 Uhack Emoji. All rights reserved.
//

import UIKit
import EmojiKit

class EmojiTalkHelper: NSObject {

    static let fileName = "emojiJSON.json"
    
    class func initializeAndReturnEmojis(completion: ([Emoji] -> Void)) {
        if fileExists() { //read and return
            readEmojisFromFile({ (emojiList) in
                completion(emojiList)
            })
        } else { //write defaults
            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource("DefaultEmojis", ofType: "json")
            let fileContent = try? NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            
            let writePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: writePath)
            do {
                try fileContent!.writeToURL(url.URLByAppendingPathComponent(fileName), atomically: false, encoding: NSUTF8StringEncoding)
                
                readEmojisFromFile({ (emojiList) in
                    completion(emojiList)
                })
            }
            catch {
                print("error saving")
            }
        }
    }
    
    class func fileExists() -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent(fileName).path!
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(filePath)
    }
    
    class func addEmoji(emoji: Emoji) {
        let emojiList = initializeAndReturnEmojis { (emojiList) in
            var newEmojiList = emojiList
            newEmojiList.append(emoji)
            writeEmojisToFile(newEmojiList)
        }
    }
    
    class func resetEmojis() {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("DefaultEmojis", ofType: "json")
        let fileContent = try? NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        
        let writePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: writePath)
        do {
            try fileContent!.writeToURL(url.URLByAppendingPathComponent(fileName), atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("error saving")
        }

    }
    
    class func writeEmojisToFile(emojiList: [Emoji]) {
        
        var emojiString = "["
        
        for emoji in emojiList {
            emojiString += "{\"character\":\"\(emoji.character)\", \"groups\":[\"emoji\"],\"name\":\"\(emoji.name)\", \"aliases\":[]},"
        }
        
        emojiString = String(emojiString.characters.dropLast()) //remove last comma
        emojiString += "]"
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        do {
            try emojiString.writeToURL(url.URLByAppendingPathComponent(fileName), atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("error saving")
        }
    }
    
    class func readEmojisFromFile(completion: ([Emoji] -> Void)) {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path).URLByAppendingPathComponent(fileName)
        
        let emojiData =  NSData(contentsOfURL: url)
        
        guard let data = emojiData else {
            return
        }
        
        let fetcher = EmojiFetcher()
        fetcher.allEmojis(data) { emojiResults in
            completion(emojiResults)
        }
        
    }
    
}
