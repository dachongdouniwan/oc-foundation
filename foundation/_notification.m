//
//  _notification.m
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_pragma_push.h"
#import "_precompile.h"
#import "_notification.h"
#import "foundation/_foundation.h"

#pragma mark -

@implementation NSNotification(Extension)

#pragma mark -

- (BOOL)is:(NSString *)name {
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix {
    return [self.name hasPrefix:prefix];
}

+ (instancetype)notificationWithName:(NSString *)aName {
    return [NSNotification notificationWithName:aName object:nil];
}

@end

#pragma mark -

@implementation NSObject(NotificationResponder)

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    
    NSArray * array = [notificationName componentsSeparatedByString:@"."];
    if ( array && array.count > 1 )
    {
        //		NSString * prefix = (NSString *)[array objectAtIndex:0];
        NSString * clazz = (NSString *)[array objectAtIndex:1];
        NSString * name = (NSString *)[array objectAtIndex:2];
        
        {
            NSString * selectorName;
            SEL selector;
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:notificationName
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray * methods = [[self class] methodsWithPrefix:@"handleNotification_" untilClass:[NSObject class]];
    
    if ( nil == methods || 0 == methods.count )
    {
        return;
    }
    
    for ( NSString * selectorName in methods )
    {
        SEL sel = NSSelectorFromString( selectorName );
        if ( NULL == sel )
            continue;
        
        NSMutableString * notificationName = [self performSelector:sel];
        if ( nil == notificationName  )
            continue;
        
        [self observeNotification:notificationName];
    }
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark -

@implementation NSObject (NotificationSender)

+ (BOOL)postNotification:(NSString *)name
{
    logi( @"Notification '%@'", [name stringByReplacingOccurrencesOfString:@"notify." withString:@""] );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

@end

#pragma mark -

@implementation _Notification

@end

#import "_pragma_pop.h"
