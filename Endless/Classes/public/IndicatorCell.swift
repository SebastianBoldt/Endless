import UIKit

final class IndicatorCell: UICollectionViewCell {
    var state: IndicatorCellState = .unselected  {
        didSet {
            update()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            state = isSelected ? .selected : .unselected
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
        backgroundColor = .white
        layer.addSublayer(dotLayer)
        state = .unselected
    }
    
    func update() {
        switch state {
        case .unselected:
            dotLayer.fillColor = UIColor.lightGray.cgColor
            dotLayer.transform = CATransform3DMakeScale(1, 1, 1)
        case .selected:
            dotLayer.fillColor = UIColor.darkGray.cgColor
            dotLayer.transform = CATransform3DMakeScale(1, 1, 1)
        case .small:
            dotLayer.fillColor = UIColor.lightGray.cgColor
            dotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
        }
    }
}
