//
//  _notification.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#undef	notification
#define notification( name ) \
static_property( name )

#undef	def_notification
#define def_notification( name ) \
def_static_property2( name, @"notification", NSStringFromClass([self class]) )

#undef	def_notification_alias
#define def_notification_alias( name, alias ) \
alias_static_property( name, alias )

#undef	makeNotification
#define	makeNotification( ... ) \
macro_string( macro_join(notification, __VA_ARGS__) )

#undef	handleNotification
#define	handleNotification( ... ) \
- (void) macro_join( handleNotification, __VA_ARGS__):(NSNotification *)notification

#undef  notification_nameof_int
#define notification_nameof_int( _int_value_ ) ([NSString stringWithFormat:@"notification.temp.%ld", (long)_int_value_])

#pragma mark -

typedef NSObject *	(^ _NotificationBlock )( NSString * name, id object );

#pragma mark -

@protocol ManagedNotification <NSObject>
@end

typedef NSNotification NotificationType;

#pragma mark -

@interface NSNotification ( Extension )

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

+ (instancetype)notificationWithName:(NSString *)aName;

@end

#pragma mark -

@interface NSObject ( NotificationResponder )

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)observeAllNotifications;

- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

@end

#pragma mark -

@interface NSObject ( NotificationSender )

+ (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name;

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end

#pragma mark - 

@interface _Notification : NSObject

@end
