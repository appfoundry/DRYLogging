import Foundation

/**
 *  A filter, used by DRYLoggingAppender instances, to decide whether they should append a message to their underlying
 *  system or not.
 *
 *  @since 3.0
 */
public protocol AppenderFilter : class {
    
    /**
     *  When the message is accepted by this filter, returns DRYLoggingAppenderFilterDecissionAccept.
     *  When the filter cannot decide on what to do with the message, returns DRYLoggingAppenderFilterDecissionNeutral
     *  When the message is denied by this filter, returns DRYLoggingAppenderFilterDecissionDeny
     *
     *  @param message The message to make a decission for.
     */
    func decide(_ message: LoggingMessage!) -> AppenderFilterDecission
}
