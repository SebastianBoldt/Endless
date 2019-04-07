import Foundation

/**
    We need to restrict the max number at the moment because we use scrollPosition center
    and calculate the intrinsic size base on numberOfMaxitems and the spacing between them
 */

public enum MaxNumberOfDots: Int {
    case three = 3
    case five = 5
    case seven = 7
    case nine = 9
    case eleven = 11
    case thirteen = 13
}
