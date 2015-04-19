//
//  DRYLoggingBackupRoller.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import "DRYLoggingBackupRoller.h"

@interface DRYLoggingBackupRollerOperation : NSObject {
    NSString *_fileName;
    NSString *_extension;
    NSString *_directory;
    NSUInteger _lastIndex;
}

- (instancetype)initWithDirectory:(NSString *)directory fileName:(NSString *)fileName extension:(NSString *)extension lastIndex:(NSUInteger)lastIndex;

- (void)performRolling;

@end

@interface DRYLoggingBackupRoller () {
    NSUInteger _maximumNumberOfFiles;
}
@end

@implementation DRYLoggingBackupRoller

+ (instancetype)rollerWithMaximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles {
    return [[self alloc] initWithMaximumNumberOfFiles:maximumNumberOfFiles];
}

- (instancetype)init {
    return [self initWithMaximumNumberOfFiles:5];
}

- (instancetype)initWithMaximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles {
    self = [super init];
    if (self) {
        _maximumNumberOfFiles = maximumNumberOfFiles;
    }
    return self;
}

- (void)rollFileAtPath:(NSString *)path {
    @synchronized (self) {
        NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        NSString *extension = path.pathExtension;
        NSString *directory = [path stringByDeletingLastPathComponent];
        DRYLoggingBackupRollerOperation *operation = [[DRYLoggingBackupRollerOperation alloc] initWithDirectory:directory fileName:fileName extension:extension lastIndex:_maximumNumberOfFiles - 1];
        [operation performRolling];
    }
}


@end

@implementation DRYLoggingBackupRollerOperation {
    NSFileManager *_manager;
}

- (instancetype)initWithDirectory:(NSString *)directory fileName:(NSString *)fileName extension:(NSString *)extension lastIndex:(NSUInteger)lastIndex {
    self = [super init];
    if (self) {
        _directory = directory;
        _fileName = fileName;
        _extension = extension;
        _lastIndex = lastIndex;
        _manager = [NSFileManager defaultManager];
    }
    return self;
}

- (void)performRolling {
    [self _deleteLastFileIfNeeded];
    for (NSInteger i = _lastIndex; i >= 0; i--) {
        [self _moveFileToNextIndexFromIndex:(NSUInteger) i];
    }
}

- (void)_moveFileToNextIndexFromIndex:(NSUInteger)index {
    NSString *potentialExistingRolledFile = [self _fileAtIndex:index];
    if ([_manager fileExistsAtPath:potentialExistingRolledFile]) {
        NSString *newPath = [self _fileAtIndex:(index + 1)];
        [_manager moveItemAtPath:potentialExistingRolledFile toPath:newPath error:nil];
    }
}

- (void)_deleteLastFileIfNeeded {
    NSString *lastFile = [self _fileAtIndex:_lastIndex];
    if ([_manager fileExistsAtPath:lastFile]) {
        NSError *error;
        if (![_manager removeItemAtPath:lastFile error:&error]) {
            NSLog(@"Unable to delete last file: %@", error);
        }
    }
}

- (NSString *)_fileAtIndex:(NSUInteger)index {
    return [_directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@", _fileName, index ? @(index) : @"", _extension]];
}


@end