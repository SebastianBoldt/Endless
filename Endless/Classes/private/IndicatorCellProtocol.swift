import Foundation

protocol IndicatorCellProtocol {
    var isSelected: Bool {  get set }
    func update(state: IndicatorCellState, animated: Bool)
    func set(configuration: Configuration)
}
