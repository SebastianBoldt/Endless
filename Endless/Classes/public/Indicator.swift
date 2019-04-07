import UIKit


public final class Indicator: UIView {
    
    // Move this crap to configuration model
    let widthOfItem: CGFloat = 10
    let numberOfItems = 20
    let maxNumberOfVisibleItems = 5 // This has to be odd
    let spacingBetweenItems: CGFloat = 15
    var selectedIndex = 0
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = UIColor.gray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupInitialSelection()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        setupInitialSelection()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension Indicator {
    private func setupConstraints() {
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let spacing = CGFloat(maxNumberOfVisibleItems - 1) * spacingBetweenItems
        widthAnchor.constraint(equalToConstant: CGFloat(maxNumberOfVisibleItems) * widthOfItem + spacing).isActive = true
    }
    
    private func setupInitialSelection() {
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
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
        return CGSize(width: widthOfItem, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /**
            We just want to update the look if there are more items available then visible
         */
        guard numberOfItems > maxNumberOfVisibleItems, indexPath.row != selectedIndex else {
            return
        }
        updateCellBeforeScrollUpdate(collectionView)
        (cell as? IndicatorCell)?.state = .small
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenItems
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


