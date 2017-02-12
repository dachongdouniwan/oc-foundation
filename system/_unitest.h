//
//  _unitest.h
//  component
//
//  Created by fallen.ink on 4/18/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
 */

#pragma mark -

#define xct_waitfor( _case_name_ ) do {\
    [self expectationForNotification:@"suite.unitest.synchronized" object:nil handler:nil];\
    [self waitForExpectationsWithTimeout:30 handler:^(NSError * _Nullable error) {\
        LOG(@"[%@] case test expired on: %@", _case_name_, error);\
    }];\
} while (0);

#define xct_notify \
    [[NSNotificationCenter defaultCenter] postNotificationName:@"suite.unitest.synchronized" object:nil];

#pragma mark -

#define xct_block \
    CFRunLoopRun();

#define xct_goon \
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();\
    CFRunLoopStop(runLoopRef);

#pragma mark -

@interface _unitest : NSObject

@end
