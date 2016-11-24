# DRYLogging

[![CI Status](http://img.shields.io/travis/Michael Seghers/DRYLogging.svg?style=flat)](https://travis-ci.org/appfoundry/DRYLogging)
[![Version](https://img.shields.io/cocoapods/v/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)
[![License](https://img.shields.io/cocoapods/l/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)
[![Platform](https://img.shields.io/cocoapods/p/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)

DRYLogging is a logging framework for Swift, based on logging frameworks seen in other languages.

## Short overview

The idea behind these logging frameworks is that loggers are hierarchical of nature to facilitate configuration of common
log levels and the way log messages are written to underlying systems.

If a logger doesn't hold any specific level information, it will ask it's parent on which level it should log. This means
that you don't need to configure a level for each and every logger in your system. If, however you want to log on a 
different level for a specific logger (and its children) you can override the parent's settings. You can even change log 
levels at runtime, or have different log configurations in different steps of your developement. 

Furthermore, if a parent has a so called "appender", its children will also append their log messages to this appender.
This is an additive process. 

Messages are formatted to strings before they are appended to an appender through the use of log formatters. 
 
Last but not least, these appenders themselves can decide to accept or deny a message by using a filter mechanism.
 
For more detailed information, you should check out the API documentation, available on [CocoaDocs](http://cocoadocs.org/docsets/DRYLogging/)
and the example project, found in the Example directory of the git repository.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### TL;DR version

Import DRYLogging wherever you need logging

```Swift
import DRYLogging
```

Create a logger, using the LoggerFactory

```Swift
//Create a logger named "FancyLogger". This logger will automatically have the root logger as its parent.
let logger = LoggerFactory.logger(named: "FancyLogger")
```

If you want your messages to appear on the console, add the console appender to your logger (or one of its parents). 
Adding the appender on the root logger, makes sure all loggers can append their messages too.

```Swift
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "HH:mm:ss.SSS"
let formatter = ClosureBasedMessageFormatter(closure: {
return "[\($0.level) - \(dateFormatter.string(from: $0.date))] <T:\($0.threadName) - S:\($0.className) - M:\($0.methodName) - L:\($0.lineNumber)> - \($0.message)"
})
LoggerFactory.rootLogger.add(appender: ConsoleAppender(formatter: formatter))
```

By default, the root logger will set it's level to LogLevel.info, so info, warning and error logs will show up once 
we add an appender.

Now we are ready to log a messages: 

```Objective-C
let world = "earth"
logger.info("Hello, \(world)")
```

This message will be printed to the console.

You can all see this in action in the example app too.

For more information on log levels and appenders, refer to the API documentation. 

## Installation

DRYLogging is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DRYLogging"
```

## Author

Mike Seghers, AppFoundry

## License

DRYLogging is available under the MIT license. See the LICENSE file for more info.
