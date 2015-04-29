# DRYLogging

[![CI Status](http://img.shields.io/travis/Michael Seghers/DRYLogging.svg?style=flat)](https://travis-ci.org/appfoundry/DRYLogging)
[![Version](https://img.shields.io/cocoapods/v/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)
[![License](https://img.shields.io/cocoapods/l/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)
[![Platform](https://img.shields.io/cocoapods/p/DRYLogging.svg?style=flat)](http://cocoapods.org/pods/DRYLogging)

DRYLogging is a logging framework for Objective-C based on logging frameworks seen in other languages.

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

Import the DRYLogging header wherever you need logging

```Objective-C
#import <DRYLogging/DRYLogging.h>
```

Create a logger, using the LoggerFactory

```Objective-C
//Create a logger named "FanceLogger". This logger will automatically have the root logger as its parent.
id<DRYLogger> logger = [DRYLoggerFactory loggerWithName:@"FancyLogger"];
```

You can also use a macro to get the same result:

```Objective-C
id<DRYLogger> logger = DRYLogger(@"FancyLogger");
```

If you want your messages to appear on the console, add the console appender to the root logger. Adding the appender on 
the root logger, makes sure all loggers can append their messages too.

```Objective-C
id <DRYLoggingMessageFormatter> formatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
    return [NSString stringWithFormat:@"%@ -[%@ %@] <%@> - %@", [NSString stringFromDRYLoggingLevel:message.level], message.className, message.methodName, message.lineNumber, message.message];
}];
id<DRYLoggingAppender> appender = [[DRYLoggingConsoleAppender alloc] initWithFormatter:formatter];
[[DRYLoggerFactory rootLogger] addAppender:appender];
```

By default, the root logger will set it's level to INFO, so info, warning and error logs will show up once we add an appender.

Now we are ready to log a messages: 

```Objective-C
NSString *world = @"globe";
DRYInfo(logger, @"Hello, %@", world);
```

This message will be printed to the console.

If you plan to use a logger class wide, you can use the DRYInitializeStaticLogger macro to create a static variable called "LOGGER". 
We've also provided convenience macros that assume a LOGGER variable exists in scope. The example app uses this approach
in both the DRYAppDelegate and the DRYViewController. Here's the gist of it.

```Objective-C
@implementation DRYAppDelegate

DRYInitializeStaticLogger(@"application.DRYAppDelegate")

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //...
    DRYTrace(@"...");
    //...
    return YES;
}

//...

@end
```

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
