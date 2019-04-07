import UIKit

final class IndicatorCell: UICollectionViewCell, IndicatorCellProtocol {
    private var configuration: Configuration?
    private var state: IndicatorCellState = .unselected
    
    func set(configuration: Configuration) {
        self.configuration = configuration
    }
    
    private lazy var dotLayer: CAShapeLayer = {
        let dotSize = configuration?.dotSize ?? 10
        let dotLayer = CAShapeLayer()
        dotLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        dotLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)).cgPath
        dotLayer.fillColor = UIColor.clear.cgColor
        dotLayer.lineWidth = 1.0
        return dotLayer
    }()
    
    override var isSelected: Bool {
        didSet {
            let newState: IndicatorCellState = isSelected ? .selected : .unselected
            update(state: newState)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override var reuseIdentifier: String? {
        return Constants.indicatorCellReuseIdentifier
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotLayer.position = contentView.center
    }
}

extension IndicatorCell {
    func update(state: IndicatorCellState, animated: Bool = true) {
        self.state = state
        /**
            CALayer stuff is animated automatically so we need a way to disable this
         */
        if animated {
            updateDotLayer(for: self.state)
        } else {
            CALayer.performWithoutAnimation {
                updateDotLayer(for: self.state)
            }
        }
    }
}

extension IndicatorCell {
    private func setup() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        layer.addSublayer(dotLayer)
        update(state: .unselected)
    }
        
    private func updateDotLayer(for state: IndicatorCellState) {
        switch self.state {
            case .unselected:
                self.dotLayer.fillColor = (configuration?.unselectedDotColor ?? .lightGray).cgColor
                self.dotLayer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6)
            case .selected:
                self.dotLayer.fillColor = (configuration?.selectedDotColor ?? .darkGray).cgColor
                self.dotLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            case .small:
                self.dotLayer.fillColor = (configuration?.unselectedDotColor ?? .lightGray).cgColor
                self.dotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
        }
    }
}
