import Foundation

public struct Configuration {
    let numberOfPages: Int
    let maxNumberOfPages: Int
    let dotColor: UIColor
    
    public init(numberOfPages: Int,
                maxNumberOfPages: Int,
                dotColor: UIColor) {
        self.numberOfPages = numberOfPages
        self.maxNumberOfPages = maxNumberOfPages
        self.dotColor = dotColor
    }
}
