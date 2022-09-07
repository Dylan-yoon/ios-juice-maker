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
    lazy var fruits = [strawBerryLabel, bananaLabel, pineAppleLabel, kiwiLabel, mangoLabel]
    
    @IBOutlet weak var strawBerryBananaButton: UIButton!
    @IBOutlet weak var mangoKiwiButton: UIButton!
    @IBOutlet weak var strawBerryButton: UIButton!
    @IBOutlet weak var bananaButton: UIButton!
    @IBOutlet weak var pineAppleButton: UIButton!
    @IBOutlet weak var kiwiButton: UIButton!
    @IBOutlet weak var mangoButton: UIButton!
    
    let juiceMaker = JuiceMaker()
    let fruitStock = FruitStore().stock //길더라도 주스메이커에 있는 것을 반영해야하는가? 에 대한 고민 값을 가지고 있기 때문에?
    let stockCount = JuiceMaker().store.stock
    
//    var strawberryCount = JuiceMaker().store.stock[.strawBerry]
//    var bananaCount = JuiceMaker().store.stock[.banana]
//    var pineappleCount = JuiceMaker().store.stock[.pineApple]
//    var kiwiCount = JuiceMaker().store.stock[.kiwi]
//    var mangoCount = JuiceMaker().store.stock[.mango]
    
    var stock: [Fruit: Int] = [
        .strawBerry: 10,
        .banana: 10,
        .pineApple: 10,
        .kiwi: 10,
        .mango: 10
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stockCount = stockCount[.strawBerry] { strawBerryLabel.text = String(stockCount)}
        if let stockCount = stockCount[.banana] { bananaLabel.text = String(stockCount)}
        if let stockCount = stockCount[.pineApple] { pineAppleLabel.text = String(stockCount)}
        if let stockCount = stockCount[.kiwi] { kiwiLabel.text = String(stockCount)}
        if let stockCount = stockCount[.mango] { mangoLabel.text = String(stockCount)}
        
    }

    @IBAction func orderJuice(_ sender: UIButton) {
        
        //여기에 들어가야할 로직?
        //1. 버튼을 눌른다.
        //2. 해당 sender주스를 만들기 위해 과일의 재고를 확인한다.
        //3. 1 재고가 있으면 주스를만든다.
        //3. 2 재고를 차감한다. 끝
        //4. 1 재고가 없으면 차감 하지 않는다.
        //4. 2 알럿으로 페이지를 넘긴다.
        
        guard let sender = sender.restorationIdentifier,
            let juice = Juice(rawValue: sender) else {
            return
        }
        let orderJuiceRecipe = juice.recipe
        
        for (fruit, count) in orderJuiceRecipe {
            guard let currentFruit = stock[fruit] else { return }
            
            if currentFruit >= count {
                juiceMaker.makeJuice(juice)
                present(alertOrderIsReady(sender), animated: true, completion: nil)
                //재고 차감
            } else {
                present(alertOrderisnotReady(), animated: true, completion: nil)
                //컨트롤 전환
            }
        }
        
        
        
        
        
        
    }
    
    func alertOrderIsReady(_ juice: String) -> UIAlertController {
        let alert = UIAlertController(title: "완성!", message: "\(juice) 나왔습니다! 맛있게 드세요!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")})
        let cancle = UIAlertAction(title: "Cancle", style: .default, handler: { _ in
            NSLog("The \"Cancle\" alert occured.")})
        alert.addAction(ok)
        alert.addAction(cancle)
        
        return alert
    }
    
    func alertOrderisnotReady() -> UIAlertController {
        let alert = UIAlertController(title: "재고부족!", message: "재료가 모자라요. 재고를 수정할까요?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")})
        let cancle = UIAlertAction(title: "Cancle", style: .default, handler: { _ in
            NSLog("The \"Cancle\" alert occured.")})
        
        alert.addAction(ok)
        alert.addAction(cancle)
        
        return alert
    }
}


