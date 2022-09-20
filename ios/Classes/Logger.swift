import Foundation
import XCGLogger

public class KLLogger: XCGLogger {
    public var writeToFile = false
    public var logAPI = false
    
    public func setup(writeToFile: Bool, logAPI: Bool) {
        self.writeToFile = writeToFile
        self.logAPI = logAPI
        
        let fileDestination = FileDestination(owner: self,
                        writeToFile: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log"),
                        identifier: "advancedLogger.fileDestination",
                        shouldAppend: true,
                        appendMarker: "-- Relauched App --",
                        attributes: nil)
//        let fileDestination = AutoRotatingFileDestination(writeToFile: UIApplication.documentURL().appendingPathComponent("log"),
//                                              identifier: "advancedLogger.fileDestination",
//                                              shouldAppend: true,
//                                              appendMarker: "-- Relauched App --",
//                                              maxFileSize: 0) // no limit
//                                              maxFileSize: 10 * 1024 * 1024) // 10MB
        
        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = false
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue
        
        if writeToFile {
            log.add(destination: fileDestination)
        }
    }
}

private let emojiLogFormatter: PrePostFixLogFormatter = {
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    return emojiLogFormatter
}()

public let log: KLLogger = {
    let log = KLLogger(identifier: "advancedLogger", includeDefaultDestinations: true)
    
    // Add basic app info, version info etc, to the start of the logs
    log.logAppDetails()
    
    log.formatters = [emojiLogFormatter]
    
    return log
}()
