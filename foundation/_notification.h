//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/    /__|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
//

#import <Foundation/Foundation.h>

#pragma mark -

#undef  notification
#define notification( name ) \
        static_property( name )

#undef  def_notification
#define def_notification( name ) \
        def_static_property2( name, @"notification", NSStringFromClass([self class]) ) // 用于route, 但这里没用到

#undef  def_notification_alias
#define def_notification_alias( name, alias ) \
        alias_static_property( name, alias )

#undef  makeNotification
#define makeNotification( ... ) \
        macro_string( macro_join(notification, __VA_ARGS__) )

#undef  handleNotification
#define handleNotification( ... ) \
        - (void) macro_join( handleNotification, __VA_ARGS__):(NSNotification *)notification

#undef  notification_nameof_int
#define notification_nameof_int( _int_value_ ) \
        ([NSString stringWithFormat:@"notification.temp.%ld", (long)_int_value_])

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

- (void)handleNotification:(NSNotification *)notification; // 通知响应函数模板 ^_^

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

/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param notification NSNotification对象
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification;
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param aName    用来生成新通知的通知名称
 *  @param anObject 通知携带的对象
 */
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param aName     用来生成新通知的通知名称
 *  @param anObject  通知携带的对象
 *  @param aUserInfo 通知携带的用户信息
 */
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end

