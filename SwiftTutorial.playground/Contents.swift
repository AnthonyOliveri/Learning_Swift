
class TipCalculator {
    
    let total: Double
    let taxPercentage: Double
    let subtotal: Double
    
    init(total: Double, taxPercentage: Double) {
        self.total = total
        self.taxPercentage = taxPercentage
        subtotal = total / (taxPercentage + 1)
    }
    
    func calculateTipWithTipPercentage(tipPercentage: Double) -> Double {
        return subtotal * tipPercentage
    }
    
    func returnPossibleTips() -> [Int: Double] {
        let possibleTips: [Double] = [0.15, 0.18, 0.2]
        
        var retval = [Int: Double]()
        for possibleTip in possibleTips {
            let intPercentage = Int(possibleTip*100)
            retval[intPercentage] = calculateTipWithTipPercentage(possibleTip)
        }
        return retval
    }
}

let tipCalc = TipCalculator(total: 33.25, taxPercentage: 0.06)
tipCalc.returnPossibleTips()