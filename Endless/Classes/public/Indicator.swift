import UIKit

public protocol IndicatorProtocol {
    var selectedIndex: Int { get set }
    func setup(with configuration: Configuration)
}

public final class Indicator: UIView, IndicatorProtocol {
    public var selectedIndex = 0 {
        didSet {
            guard selectedIndex >= 0 else {
                return
            }
            
            guard selectedIndex < configuration!.numberOfPages else {
                return
            }
            
            let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
            self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    private var configuration: Configuration?
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
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
    
    public func setup(with configuration: Configuration) {
        self.configuration = configuration
        setupConstraints()
        setupInitialSelection()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension Indicator {
    private func setupConstraints() {
        guard let configuration = self.configuration else {
            return
        }
        
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let spacing = CGFloat(configuration.maxNumberOfPages.rawValue - 1) * configuration.spacing
        let widthOfItem = configuration.dotSize
        widthAnchor.constraint(equalToConstant: CGFloat(configuration.maxNumberOfPages.rawValue) * widthOfItem + spacing).isActive = true
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
        return configuration?.numberOfPages ?? 0
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
        return CGSize(width: configuration?.dotSize ?? 0, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /**
            We just want to update the look if there are more items available then visible
         */
        guard configuration!.numberOfPages > configuration!.maxNumberOfPages.rawValue, indexPath.row != selectedIndex else {
            return
        }
        updateCellBeforeScrollUpdate(collectionView)
        (cell as? IndicatorCell)?.update(state: .small, animated: false)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return configuration?.spacing ?? 0
    }
}

extension Indicator {
    struct CellAndPath {
        let indicatorCell: IndicatorCell
        let indexPath: IndexPath
    }
    
    private func udpateCellsAfterScrolling() {
        
        // Get All visible cells
        let cellAndPaths = getAllVisibleCellsAndPaths()
        
        if let first = cellAndPaths.first {
            guard first.indexPath.row != selectedIndex else {
                return
            }
            
            if first.indexPath.row == 0 {
                first.indicatorCell.update(state: .unselected)
            } else {
                first.indicatorCell.update(state: .small)
            }
        }
        
        if let last = cellAndPaths.last {
            guard last.indexPath.row != selectedIndex else {
                return
            }
            
            if last.indexPath.row == configuration!.numberOfPages - 1 {
                last.indicatorCell.update(state: .unselected)
            } else {
                last.indicatorCell.update(state: .small)
            }
        }
        
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell) else {
                continue
            }
            
            guard let indicatorCell = cell as? IndicatorCell else {
                continue
            }
            
            if indexPath.row == selectedIndex {
                indicatorCell.update(state: .selected)
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
                indicatorCell.update(state: .unselected)
            }
        }
    }
    
    private func getAllVisibleCellsAndPaths() -> [CellAndPath] {
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
        return cellAndPaths
    }
}


