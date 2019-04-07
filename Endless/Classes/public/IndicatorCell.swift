import UIKit

final class IndicatorCell: UICollectionViewCell {
    private var state: IndicatorCellState = .unselected

    
    override var isSelected: Bool {
        didSet {
            let newState: IndicatorCellState = isSelected ? .selected : .unselected
            update(state: newState)
        }
    }
    
    var dotLayer: CAShapeLayer = {
        let dotLayer = CAShapeLayer()
        dotLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        dotLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        dotLayer.strokeColor = UIColor.lightGray.cgColor
        dotLayer.fillColor = UIColor.clear.cgColor
        dotLayer.lineWidth = 1.0
        return dotLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotLayer.position = contentView.center
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override var reuseIdentifier: String? {
        return "IndicatorCell"
    }
}

extension IndicatorCell {
    func setup() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        layer.addSublayer(dotLayer)
        update(state: .unselected)
    }
    
    func update(state: IndicatorCellState, animated: Bool = true) {
        self.state = state
        let updateBlock = {
            switch self.state {
                case .unselected:
                    self.dotLayer.fillColor = UIColor.lightGray.cgColor
                    self.dotLayer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6)
                case .selected:
                    self.dotLayer.fillColor = UIColor.red.cgColor
                    self.dotLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                case .small:
                    self.dotLayer.fillColor = UIColor.lightGray.cgColor
                    self.dotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
                }
        }
        
        /**
            CALayer aniamted automatically so we need a way to disable this
        */
        if animated {
            updateBlock()
        } else {
            CALayer.performWithoutAnimation {
                updateBlock()
            }
        }
    }
}
