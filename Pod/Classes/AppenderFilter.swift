import Foundation


///  A filter, used by LoggingAppender instances, to decide whether they should append a message to their underlying
///  system or not.
///
///  - since: 3.0
///
///  - seealso: LoggingAppender
public protocol AppenderFilter : class {
    
    ///  When the message is accepted by this filter, returns AppenderFilterDecission.accept.
    ///  When the filter cannot decide on what to do with the message, returns AppenderFilterDecission.neutral
    ///  When the message is denied by this filter, returns AppenderFilterDecission.deny
    ///
    ///  - parameter message: The message to make a decission for.
    ///
    ///  - seealso: AppenderFilterDecission
    func decide(_ message: LoggingMessage) -> AppenderFilterDecission
}
