import Foundation

public extension String {
    
    func clean() -> String {
        // Remove URLs
        var str = self.replacingOccurrences(of: "@(https?://([-\\w\\.]+[-\\w])+(:\\d+)?(/([\\w/_\\.#-]*(\\?\\S+)?[^\\.\\s])?)?)@", with: "", options: .regularExpression, range: self.startIndex ..< self.endIndex)
        // Remove HTML
        str = str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: str.startIndex ..< str.endIndex)
        str = str.replacingOccurrences(of: "&#8220;", with: "“").replacingOccurrences(of: "&#8221;", with: "”")
        str = str.replacingOccurrences(of: "&#8216", with: "‘").replacingOccurrences(of: "&#8217;", with: "’")
        return str
    }
    
}
