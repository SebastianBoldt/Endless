import UIKit
import Endless

class ViewController: UIViewController {
    @IBOutlet weak private var indicator: Endless.Indicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = Endless.Configuration(numberOfPages: 200,
                                                  maxNumberOfPages: .five,
                                                  dotColor: .lightGray,
                                                  dotSize: 10,
                                                  spacing: 10)
        indicator?.setup(with: configuration)
    }
    
    @IBAction func increment(_ sender: Any) {        
        indicator.selectedIndex = indicator.selectedIndex + 1
    }
    
    @IBAction func decrement(_ sender: Any) {
        indicator.selectedIndex = indicator.selectedIndex - 1
    }
}

