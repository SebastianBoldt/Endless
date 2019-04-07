import Foundation

extension UICollectionView {
    func getAllVisibleCellsAndPaths() -> [(cell: IndicatorCell, indexPath: IndexPath)] {
        let visibleCells = self.visibleCells
        let cellAndPaths: [(cell: IndicatorCell, indexPath: IndexPath)] = visibleCells.compactMap { cell in
            guard let indexPath = self.indexPath(for: cell) else {
                return nil
            }
            
            guard let indicatorCell = cell as? IndicatorCell else {
                return nil
            }
            
            return (indicatorCell, indexPath)
        }.sorted(by: {
            return $0.indexPath.row < $1.indexPath.row
        })
        return cellAndPaths
    }
}
