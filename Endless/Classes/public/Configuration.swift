import Foundation

public struct Configuration {
    let numberOfDots: Int
    let maxNumberOfDots: MaxNumberOfDots
    let selectedDotColor: UIColor
    let unselectedDotColor: UIColor
    let dotSize: CGFloat
    let spacing: CGFloat
    
    public init(numberOfDots: Int,
                maxNumberOfDots: MaxNumberOfDots,
                selectedDotColor: UIColor,
                unselectedDotColor: UIColor,
                dotSize: CGFloat,
                spacing: CGFloat) {
        self.numberOfDots = numberOfDots
        self.maxNumberOfDots = maxNumberOfDots
        self.selectedDotColor = selectedDotColor
        self.unselectedDotColor = unselectedDotColor
        self.dotSize = dotSize
        self.spacing = spacing
    }
}

extension Configuration: Equatable {
    
}
