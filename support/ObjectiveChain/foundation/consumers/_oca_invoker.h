//
//  OCAInvoker.h
//  Objective-Chain
//
//  Created by Martin Kiss on 27.1.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import "_oca_object.h"
#import "_oca_consumer.h"
#import "_oca_producer.h"
#import "_oca_placeholder_object.h"
#import "_oca_invocation_catcher.h"





@interface OCAInvoker : OCAObject < OCAConsumer >



#define OCAInvocation(TARGET, METHOD) \
(OCAInvoker *)({ \
    OCAInvoker *invoker = nil;\
    if (TARGET) {\
        OCAInvocationCatcher *catcher = [[OCAInvocationCatcher alloc] initWithTarget:(TARGET)]; \
        [(typeof(TARGET))catcher METHOD]; \
        invoker = [[OCAInvoker alloc] initWithInvocationCatcher:catcher]; \
    }\
    invoker;\
}) \

//TODO: OCAInvocation subclass to handle flaws of NSInvocation.

- (instancetype)initWithInvocationCatcher:(OCAInvocationCatcher *)catcher;

@property (atomic, readonly, weak) id target;
@property (atomic, readonly, strong) NSInvocation *invocation;



@end


