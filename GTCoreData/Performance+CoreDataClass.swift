import Foundation
import CoreData
import Core
import Model

@objc(Performance)
public class Performance: NSManagedObject {
    
    public var dateFormat: PerformanceDateFormat? {
        guard let dateFormatString = dateFormatString else {
            return nil
        }
        return PerformanceDateFormat(rawValue: dateFormatString)
    }

}
