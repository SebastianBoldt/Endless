import Foundation

public enum MaxNumberConfiguration: Int {
    case three = 3
    case five = 5
    case seven = 7
    case nine = 9
    case eleven = 11
}

public struct Configuration {
    let numberOfPages: Int
    let maxNumberOfPages: MaxNumberConfiguration
    let dotColor: UIColor
    let dotSize: CGFloat
    let spacing: CGFloat
    
    public init(numberOfPages: Int,
                maxNumberOfPages: MaxNumberConfiguration,
                dotColor: UIColor,
                dotSize: CGFloat,
                spacing: CGFloat) {
        self.numberOfPages = numberOfPages
        self.maxNumberOfPages = maxNumberOfPages
        self.dotColor = dotColor
        self.dotSize = dotSize
        self.spacing = spacing
    }
}
