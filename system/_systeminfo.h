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

#import "_configdef.h"
#import "_singleton.h"
#import "_property.h"

#pragma mark -

typedef enum {
    OperationSystem_Unknown = 0,
    OperationSystem_Mac,
    OperationSystem_iOS
} OperationSystem;

#pragma mark - 

extern BOOL IOS8; // 准确的iOS8， 非iOS7，非iOS9
extern BOOL IOS9;

extern BOOL IOS10_OR_LATER;
extern BOOL IOS9_OR_LATER;
extern BOOL IOS8_OR_LATER;
extern BOOL IOS7_OR_LATER;
extern BOOL IOS6_OR_LATER;
extern BOOL IOS5_OR_LATER;
extern BOOL IOS4_OR_LATER;
extern BOOL IOS3_OR_LATER;

extern BOOL IOS9_OR_EARLIER;
extern BOOL IOS8_OR_EARLIER;
extern BOOL IOS7_OR_EARLIER;
extern BOOL IOS6_OR_EARLIER;
extern BOOL IOS5_OR_EARLIER;
extern BOOL IOS4_OR_EARLIER;
extern BOOL IOS3_OR_EARLIER;

extern BOOL IS_SCREEN_4_INCH;
extern BOOL IS_SCREEN_35_INCH;
extern BOOL IS_SCREEN_47_INCH;
extern BOOL IS_SCREEN_55_INCH;

#pragma mark -

@interface _SystemInfo : NSObject

@singleton( _SystemInfo )

@prop_readonly( NSString *,         now );

@prop_readonly( NSString *,			osVersion );
@prop_readonly( OperationSystem,	osType );
@prop_readonly( NSString *,			bundleVersion );
@prop_readonly( NSString *,			bundleShortVersion );
@prop_readonly( NSString *,			bundleIdentifier );
@prop_readonly( NSString *,			urlSchema );
@prop_readonly( NSString *,			deviceModel );

@prop_readonly( BOOL,				isJailBroken );
@prop_readonly( BOOL,				runningOnPhone );
@prop_readonly( BOOL,				runningOnPad );
@prop_readonly( BOOL,				requiresPhoneOS );

@prop_readonly( BOOL,				isScreenPhone );
@prop_readonly( BOOL,				isScreen320x480 );      // history
@prop_readonly( BOOL,				isScreen640x960 );      // ip4s
@prop_readonly( BOOL,				isScreen640x1136 );     // ip5, ip5s, ip6 Zoom mode
@prop_readonly( BOOL,				isScreen750x1334 );     // ip6
@prop_readonly( BOOL,				isScreen1242x2208 );    // ip6p
@prop_readonly( BOOL,				isScreen1125x2001 );    // ip6p Zoom mode

@prop_readonly( BOOL,				isScreenPad );
@prop_readonly( BOOL,				isScreen768x1024 );     // only ipad1, ipad2, ipad mini1
@prop_readonly( BOOL,				isScreen1536x2048 );

@prop_readonly( CGSize,				screenSize );

@prop_readonly( double,             totalMemory ); // 获取设备物理内存(单位：MB)
@prop_readonly( double,				availableMemory ); // 获取当前设备可用内存(单位：MB）
@prop_readonly( double,				usedMemory ); // 获取当前任务所占用的内存（单位：MB）

@prop_readonly( double,				availableDisk ); // 获取当前设备可用磁盘空间(单位：MB）

@prop_readonly( NSString *,         appSize );

@prop_readonly( NSString *,         buildCode ); // build 号
@prop_readonly( int32_t,            intAppVersion );
@prop_readonly( NSString *,         appVersion );

// accessory
@prop_readonly( BOOL,               photoCaptureAccessable ); // 拍照权限是否打开
@prop_readonly( BOOL,               photoLibraryAccessable ); // 相册权限是否打开

/**
 *  en_US, zh_CN,
 */
@prop_readonly( NSArray *,          languages ); // 系统语言
@prop_readonly( NSString *,         currentLanguage ); // 系统当前使用语言

- (NSString *)urlSchemaWithName:(NSString *)name;

- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

@end
