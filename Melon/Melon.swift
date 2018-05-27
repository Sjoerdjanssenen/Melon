//
//  Melon.swift
//  Annotater
//
//  Created by Sjoerd Janssen on 26/05/2018.
//  Copyright © 2018 Sjoerd Janssen. All rights reserved.
//

import UIKit

extension String {
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch let error {
            print(error)
            return
        }
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class Melon: NSObject {
    var template: String?
    var data: NSMutableDictionary
    
    override init() {
        self.data = NSMutableDictionary()
        self.data.setValue("Logging in", forKey: "title")
        self.data.setValue("https://api.stimuliz.com/v1/session/login", forKey: "url")
        self.data.setValue(["test1", "test2", "test3"], forKey: "items")
        
        super.init()
    }
    
    public func load(template: String) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: template), options: .mappedIfSafe)
            let contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            self.template = contents as String?
        } catch {
            // handle error
        }
    }
    
    public func parse() -> String {
        return replaceEchoes(template: &self.template!)
    }
    
    func replaceForLoops(template: inout String) -> String {
        template.removingRegexMatches(pattern: "\\{%\\sfor(.*?)in(.*?)\\s?%\\}", replaceWith: "bla")
        return template
    }
    
    func replaceEchoes(template: inout String) -> String {
        for key in self.data.allKeys {
            if (self.data.object(forKey: key) is String) {
                template.removingRegexMatches(pattern: "\\{\\{\\s?" + (key as! String) + "\\s?\\}\\}", replaceWith: (self.data.object(forKey: key) as! String))
            } else if (self.data.object(forKey: key) is NSArray) {
                let varName = template.slice(from: "{% for ", to: " in " + (key as! String) + " %}") as! String
                let repeater = template.slice(from: "{% for " + varName + " in " + (key as! String) + " %}", to: "{% endfor %}") as! String
                var insertion = ""
                
                for item in (self.data.object(forKey: key) as! NSArray) {
                    var repeated = repeater
                    repeated.removingRegexMatches(pattern: "\\{\\{\\s?" + varName + "\\s?\\}\\}", replaceWith: (item as! String))
                    insertion = insertion+repeated
                }
                
                template = template.replacingOccurrences(of: "{% for " + varName + " in " + (key as! String) + " %}" + repeater + "{% endfor %}", with: insertion)
            }
        }
        
        return template
    }
}
