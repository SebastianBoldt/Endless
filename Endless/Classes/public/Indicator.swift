import UIKit

public protocol IndicatorProtocol {
    var selectedIndex: Int { get set }
    func setup(with configuration: Configuration)
}

public final class Indicator: UIView, IndicatorProtocol {
    public var selectedIndex = 0 {
        didSet {
            guard let configuration = configuration else {
                return
            }
            
            guard selectedIndex >= 0 else {
                return
            }
            
            guard selectedIndex < configuration.numberOfDots else {
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
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: Constants.indicatorCellReuseIdentifier)
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
        let spacing = CGFloat(configuration.maxNumberOfDots.rawValue - 1) * configuration.spacing
        let widthOfItem = configuration.dotSize
        widthAnchor.constraint(equalToConstant: CGFloat(configuration.maxNumberOfDots.rawValue) * widthOfItem + spacing).isActive = true
    }
    
    private func setupInitialSelection() {
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension Indicator: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration?.numberOfDots ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.indicatorCellReuseIdentifier, for: indexPath)
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
        guard let configuration = configuration else {
            return
        }
        /**
            We just want to update the look if there are more items available then visible
         */
        guard configuration.numberOfDots > configuration.maxNumberOfDots.rawValue, indexPath.row != selectedIndex else {
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
    private func udpateCellsAfterScrolling() {
        guard let configuration = configuration else {
            return
        }
        
        // Get All visible cells
        let cellAndPaths = getAllVisibleCellsAndPaths()
        
        if let first = cellAndPaths.first {
            guard first.indexPath.row != selectedIndex else {
                return
            }
            
            if first.indexPath.row == 0 {
                first.cell.update(state: .unselected)
            } else {
                first.cell.update(state: .small)
            }
        }
        
        if let last = cellAndPaths.last {
            guard last.indexPath.row != selectedIndex else {
                return
            }
            
            if last.indexPath.row == configuration.numberOfDots - 1 {
                last.cell.update(state: .unselected)
            } else {
                last.cell.update(state: .small)
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
}


