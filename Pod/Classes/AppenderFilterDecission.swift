import Foundation

/**
 *  The result of a filter's decision on what to do with a message.
 *
 *  @since 1.1
 */
public enum AppenderFilterDecission : Int {
    
    
    /**
     *  Returned when the filter accepts the message.
     */
    case accept
    
    /**
     *  Returned when the filter can not decide what to do with the message.
     */
    case neutral
    
    /**
     *  Returned when the filter denies the message.
     */
    case deny
}
