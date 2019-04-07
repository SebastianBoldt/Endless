import Foundation

public struct Configuration {
    let numberOfDots: Int
    let maxNumberOfDots: MaxNumberOfDots
    let dotColor: UIColor
    let dotSize: CGFloat
    let spacing: CGFloat
    
    public init(numberOfDots: Int,
                maxNumberOfDots: MaxNumberOfDots,
                dotColor: UIColor,
                dotSize: CGFloat,
                spacing: CGFloat) {
        self.numberOfDots = numberOfDots
        self.maxNumberOfDots = maxNumberOfDots
        self.dotColor = dotColor
        self.dotSize = dotSize
        self.spacing = spacing
    }
}
