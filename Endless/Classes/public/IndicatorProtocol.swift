import Foundation

public protocol IndicatorProtocol {
    var selectedIndex: Int { get set }
    func setup(with configuration: Configuration)
}
