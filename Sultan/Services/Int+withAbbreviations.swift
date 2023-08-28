import Foundation


extension Int {
    var withAbbreviation: String {
        guard self != 0 else { return String(self) }
        let abbreviations = ["K", "M", "B", "T", "P", "Y"]
        var grade = 0.0
        var mod = Double(self) / pow(10, grade * 3)
       
        repeat {
            grade += 1
            mod = Double(self) / pow(10, grade * 3)
        } while abs(mod) >= 1
        
        grade -= 1
        mod = Double(self) / pow(10, grade * 3)
        if grade >= 1 {
            return String(format: "%.1f", mod) + abbreviations[Int(grade - 1)]
        }
        return String(self)
    }
}
