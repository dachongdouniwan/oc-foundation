//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/     \_|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
//

#import "_precompile.h"
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

@interface _System : NSObject

@singleton( _System )

@prop_readonly( NSString *,         now );

@prop_readonly( NSString *,			osVersion );
@prop_readonly( OperationSystem,	osType );
@prop_readonly( NSString *,			bundleVersion );
@prop_readonly( NSString *,			bundleShortVersion );
@prop_readonly( NSString *,			bundleIdentifier );
@prop_readonly( NSString *,			urlSchema );
@prop_readonly( NSString *,			deviceModel );
@prop_readonly( NSString *,			deviceUDID ); // Stored in keychain

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

@prop_readonly( NSString *,         buildCode ); // build 号
@prop_readonly( int32_t,            intAppVersion );
@prop_readonly( NSString *,         appVersion );

// accessory
@prop_readonly( BOOL,               photoCaptureAccessable ); // 拍照权限是否打开
@prop_readonly( BOOL,               photoLibraryAccessable ); // 相册权限是否打开

// uuid inspired by FCUUID
@prop_readonly( NSString *,         uuid ); // changes each time (no persistent)
@prop_readonly( NSString *,         uuidForSession ); // changes each time the app gets launched (persistent to session)
@prop_readonly( NSString *,         uuidForInstallation ); // changes each time the app gets installed (persistent to installation)
@prop_readonly( NSString *,         uuidForVendor ); // changes each time all the apps of the same vendor are uninstalled (this works exactly as identifierForVendor)
@prop_readonly( NSString *,         uuidForDevice ); // changes only on system reset, this is the best replacement to the good old udid (persistent to device)

/**
 *  en_US, zh_CN,
 */
@prop_readonly( NSArray *,          languages ); // 系统语言

- (NSString *)urlSchemaWithName:(NSString *)name;

- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

@end
