//
//  ProfanityFilter.swift
//  KarmaPro
//
//  Created by Macbook Pro on 20/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

class ProfanityFilter: NSObject
{
    
    static let sharedInstance = ProfanityFilter()
    private override init() {}
      // Customize as needed
    private let dirtyWords = "\\b(ducker|Bitch|Asshole|Fucker|Faggot|Nigger|Spic|Whore|Ho|Slut|Wetback|Twat|Kill Yourself|Kill You|Go Die|Motherfucker|Jigaboo|Sand Nigger|fuck|fucker|Cunt|Dick|mother ducker|motherducker|shot|bad word|another bad word|)\\b"
    
    // Courtesy of Martin R
    // https://stackoverflow.com/users/1187415/martin-r
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    public func cleanUp(_ string: String) -> String {
        let dirtyWords = matches(for: self.dirtyWords, in: string)
        
        if dirtyWords.count == 0 {
            return string
        } else {
            var newString = string
            
            dirtyWords.forEach({ dirtyWord in
                let newWord = String(repeating: "*", count: dirtyWord.characters.count)
                newString = newString.replacingOccurrences(of: dirtyWord, with: newWord, options: [.caseInsensitive])
            })
            
            return newString
        }
    }

}
