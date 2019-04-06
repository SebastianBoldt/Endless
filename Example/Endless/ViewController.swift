import UIKit
import Endless

class ViewController: UIViewController {
    @IBOutlet weak private var indicator: Endless.Indicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func increment(_ sender: Any) {        
        indicator?.increment()
    }
    
    @IBAction func decrement(_ sender: Any) {
        indicator?.decrement()
    }
}

