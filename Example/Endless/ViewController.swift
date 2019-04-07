import UIKit
import Endless

class ViewController: UIViewController {
    @IBOutlet weak private var indicator: Endless.Indicator!
    @IBOutlet weak var exampleCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleCollectionView?.delegate = self
        exampleCollectionView?.dataSource = self
        let configuration = Endless.Configuration(numberOfDots: 10,
                                                  maxNumberOfDots: .five,
                                                  selectedDotColor: UIColor(named: "Selected")!,
                                                  unselectedDotColor: .lightGray,
                                                  dotSize: 10,
                                                  spacing: 10)
        indicator?.setup(with: configuration)
        exampleCollectionView?.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exampleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: indexPath)
        exampleCell.contentView.backgroundColor = UIColor.random()
        return exampleCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        indicator.selectedIndex = Int(offSet + horizontalCenter) / Int(width)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIColor {
    static func random () -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0)
    }
}
