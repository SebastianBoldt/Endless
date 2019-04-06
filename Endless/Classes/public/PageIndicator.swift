import UIKit

public struct Dot {
    var visible: Bool
    var layer: CAShapeLayer
}

public final class PageIndicator: UIView {
    
    private var configuration: Configuration
    private var dots: [Dot] = []
    
    public var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex >= 0 else {
                selectedIndex = 0
                return
            }
            
            guard selectedIndex <= configuration.maxNumberOfPages else {
                selectedIndex = configuration.maxNumberOfPages
                return
            }
            
            update()
        }
    }
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageIndicator {
    func setup() {
        var position: CGFloat = 0
        for i in 0...configuration.numberOfPages {
            guard i <= configuration.maxNumberOfPages else {
                appendAdditionalLayers()
                break
            }
            
            let shapeLayer = makeDotLayer()
            if i == 0 {
                shapeLayer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
            }
            shapeLayer.frame = CGRect(x: position, y: 0, width: Metrics.dotSize, height: Metrics.dotSize)
            layer.addSublayer(shapeLayer)
            position += Metrics.dotSize + Metrics.defaultSpacing
            
            dots.append(Dot(visible: true, layer: shapeLayer))
        }
    }
}

extension PageIndicator {
    //TODO: Move to Dot-Layer Factory
    private func makeDotLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Metrics.dotSize, height: Metrics.dotSize)).cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = configuration.dotColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }
    
    private func appendAdditionalLayers() {
        let additionalLayer = makeDotLayer()
        dots.append(Dot(visible: false, layer: additionalLayer))
    }
    
    private func update() {
        if configuration.numberOfPages < configuration.maxNumberOfPages {
            for (index,dot) in dots.enumerated() {
                if index == selectedIndex {
                    dot.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
                } else {
                    dot.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                }
            }
        } else {
            // Make a Shift update
        }
    }
}
