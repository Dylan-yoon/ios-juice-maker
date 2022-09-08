//
//  Created by Baem, Jeremy
//
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var strawBerryLabel: UILabel!
    @IBOutlet weak var bananaLabel: UILabel!
    @IBOutlet weak var pineAppleLabel: UILabel!
    @IBOutlet weak var kiwiLabel: UILabel!
    @IBOutlet weak var mangoLabel: UILabel!
    
    @IBOutlet weak var strawBerryBananaButton: UIButton!
    @IBOutlet weak var mangoKiwiButton: UIButton!
    @IBOutlet weak var strawBerryButton: UIButton!
    @IBOutlet weak var bananaButton: UIButton!
    @IBOutlet weak var pineAppleButton: UIButton!
    @IBOutlet weak var kiwiButton: UIButton!
    @IBOutlet weak var mangoButton: UIButton!
    
    let juiceMaker = JuiceMaker()
    lazy var fruitStock = juiceMaker.store.stock
    var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelDefaultValue()
        observation = juiceMaker.store.observe(\.stock, options: [.new], changeHandler: {
            (object, changes) in
            guard let newValue = changes.newValue else {
                return
            }
            
            self.updateStock(newValue)
            self.setLabelDefaultValue()
        })
    }
    
    func updateStock(_ newValue: [String: Int]) {
        fruitStock = newValue
    }
    
    func setLabelDefaultValue() {
        strawBerryLabel.text = juiceMaker.store.stock["딸기"]?.description
        bananaLabel.text = juiceMaker.store.stock["바나나"]?.description
        pineAppleLabel.text = juiceMaker.store.stock["파인애플"]?.description
        kiwiLabel.text = juiceMaker.store.stock["키위"]?.description
        mangoLabel.text = juiceMaker.store.stock["망고"]?.description
    }
    
    @IBAction func orderJuice(_ sender: UIButton) {
        if let sender = sender.restorationIdentifier,
            let juice = Juice(rawValue: sender) {
            if juiceMaker.requestStockAvailability(for: juice) {
                juiceMaker.store.useStockForRecipe(of: juice)
                present(alertOrderIsReady(juice), animated: true, completion: nil)
            } else {
                present(alertOrderIsNotReady(), animated: true, completion: nil)
            }
        }
    }
    
    func showStockEditor() {
        guard let stockEditorViewController = self.storyboard?.instantiateViewController(withIdentifier: "StockEditorViewController") else { return }
        self.present(stockEditorViewController, animated: true, completion: nil)
    }
    
    func alertOrderIsReady(_ juice: Juice) -> UIAlertController {
        let alert = UIAlertController(title: "완성!", message: "\(juice.rawValue) 나왔습니다! 맛있게 드세요!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")})
        alert.addAction(ok)
        
        return alert
    }
    
    func alertOrderIsNotReady() -> UIAlertController {
        let alert = UIAlertController(title: "재고 부족!", message: "재료가 모자라요. 재고를 수정할까요?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            self.showStockEditor()
        })
        let cancle = UIAlertAction(title: "Cancle", style: .default, handler: { _ in
            NSLog("The \"Cancle\" alert occured.")})
        alert.addAction(ok)
        alert.addAction(cancle)
        
        return alert
    }
}

