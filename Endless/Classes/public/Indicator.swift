import UIKit

public final class Indicator: UIView {
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.backgroundColor = UIColor.white
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: "IndicatorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let numberOfItems = 20
    let maxNumberOfVisibleItems = 5 // This has to be odd
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setup() {
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        prepareInsets()
    }
    
    public func increment() {
        guard selectedIndex > 0 else {
            return
        }
        selectedIndex = selectedIndex - 1
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    public func decrement() {
        guard selectedIndex < numberOfItems - 1 else {
            return
        }
        selectedIndex = selectedIndex + 1
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func prepareInsets() {
        let leftInset = max(0,((collectionView.frame.width - collectionView.contentSize.width) / 2))
        collectionView.contentInset.left = leftInset
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension Indicator: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndicatorCell", for: indexPath)
        return cell
    }
}

extension Indicator: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        udpateCellsAfterScrolling()
    }
}

extension Indicator: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / CGFloat(maxNumberOfVisibleItems)
        return CGSize(width: size, height: size)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /**
            We just want to update the look if there are more items available then visible
         */
        guard numberOfItems > maxNumberOfVisibleItems else {
            return
        }
        updateCellBeforeScrollUpdate(collectionView)
        (cell as? IndicatorCell)?.state = .small
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension Indicator {
    struct CellAndPath {
        let indicatorCell: IndicatorCell
        let indexPath: IndexPath
    }
    
    private func udpateCellsAfterScrolling() {
        let visibleCells = self.collectionView.visibleCells
        let cellAndPaths: [CellAndPath] = visibleCells.compactMap { cell in
            guard let indexPath = collectionView.indexPath(for: cell) else {
                return nil
            }
            
            guard let indicatorCell = cell as? IndicatorCell else {
                return nil
            }
            
            return CellAndPath(indicatorCell: indicatorCell, indexPath: indexPath)
            }.sorted(by: {
                return $0.indexPath.row < $1.indexPath.row
            })
        
        if let first = cellAndPaths.first {
            guard first.indexPath.row != selectedIndex else {
                return
            }
            
            if first.indexPath.row == 0 {
                first.indicatorCell.state = .unselected
            } else {
                first.indicatorCell.state = .small
            }
        }
        
        if let last = cellAndPaths.last {
            guard last.indexPath.row != selectedIndex else {
                return
            }
            
            if last.indexPath.row == numberOfItems - 1 {
                last.indicatorCell.state = .unselected
            } else {
                last.indicatorCell.state = .small
            }
        }
    }
    
    private func updateCellBeforeScrollUpdate(_ collectionView: UICollectionView) {
        let visibleCells = collectionView.visibleCells
        print(visibleCells.count)
        for cell in visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell) else {
                continue
            }
            
            guard let indicatorCell = cell as? IndicatorCell else {
                continue
            }
            
            if indexPath.row != selectedIndex {
                indicatorCell.state = .unselected
            }
        }
    }
}


