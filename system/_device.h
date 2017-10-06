#import "_configdef.h"
#import "_singleton.h"
#import "_property.h"

#pragma mark -

typedef NS_ENUM(NSUInteger, Hardware) {
    NOT_AVAILABLE,
    
    IPHONE_2G,
    IPHONE_3G,
    IPHONE_3GS,
    
    IPHONE_4,
    IPHONE_4_CDMA,
    IPHONE_4S,
    
    IPHONE_5,
    IPHONE_5_CDMA_GSM,
    IPHONE_5C,
    IPHONE_5C_CDMA_GSM,
    IPHONE_5S,
    IPHONE_5S_CDMA_GSM,
    
    IPHONE_6,
    IPHONE_6_PLUS,
    IPHONE_6S,
    IPHONE_6S_PLUS,
    
    
    IPOD_TOUCH_1G,
    IPOD_TOUCH_2G,
    IPOD_TOUCH_3G,
    IPOD_TOUCH_4G,
    IPOD_TOUCH_5G,
    
    IPAD,
    IPAD_2,
    IPAD_2_WIFI,
    IPAD_2_CDMA,
    IPAD_3,
    IPAD_3G,
    IPAD_3_WIFI,
    IPAD_3_WIFI_CDMA,
    IPAD_4,
    IPAD_4_WIFI,
    IPAD_4_GSM_CDMA,
    
    IPAD_MINI,
    IPAD_MINI_WIFI,
    IPAD_MINI_WIFI_CDMA,
    IPAD_MINI_RETINA_WIFI,
    IPAD_MINI_RETINA_WIFI_CDMA,
    IPAD_MINI_3_WIFI,
    IPAD_MINI_3_WIFI_CELLULAR,
    IPAD_MINI_RETINA_WIFI_CELLULAR_CN,
    
    IPAD_AIR_WIFI,
    IPAD_AIR_WIFI_GSM,
    IPAD_AIR_WIFI_CDMA,
    IPAD_AIR_2_WIFI,
    IPAD_AIR_2_WIFI_CELLULAR,
    
    SIMULATOR
};

typedef enum {
    OperationSystem_Unknown = 0,
    OperationSystem_Mac,
    OperationSystem_iOS
} OperationSystem;

#pragma mark - 

extern BOOL IOS8; // 准确的iOS8， 非iOS7，非iOS9
extern BOOL IOS9;
extern BOOL iOS10;
extern BOOL iOS11;

extern BOOL iOS11_or_later;
extern BOOL IOS10_OR_LATER;
extern BOOL IOS9_OR_LATER;
extern BOOL IOS8_OR_LATER;
extern BOOL IOS7_OR_LATER;
extern BOOL IOS6_OR_LATER;
extern BOOL IOS5_OR_LATER;
extern BOOL IOS4_OR_LATER;
extern BOOL IOS3_OR_LATER;

extern BOOL iOS11_or_earlier;
extern BOOL IOS9_OR_EARLIER;
extern BOOL IOS8_OR_EARLIER;
extern BOOL IOS7_OR_EARLIER;
extern BOOL IOS6_OR_EARLIER;
extern BOOL IOS5_OR_EARLIER;
extern BOOL IOS4_OR_EARLIER;
extern BOOL IOS3_OR_EARLIER;

extern BOOL IS_SCREEN_4_INCH;
extern BOOL IS_SCREEN_35_INCH;
extern BOOL IS_SCREEN_47_INCH; // , design area: 750x1334 @2x
extern BOOL IS_SCREEN_55_INCH;
extern BOOL is_screen_58_inch; // 458 ppi, Safe design area: 750x1468 @2x

#pragma mark -

@interface _Device : NSObject

@singleton( _Device )

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

// uuid inspired by FCUUID
@prop_readonly( NSString *,         uuid ); // changes each time (no persistent)
@prop_readonly( NSString *,         uuidForSession ); // changes each time the app gets launched (persistent to session)
@prop_readonly( NSString *,         uuidForInstallation ); // changes each time the app gets installed (persistent to installation)
@prop_readonly( NSString *,         uuidForVendor ); // changes each time all the apps of the same vendor are uninstalled (this works exactly as identifierForVendor)
@prop_readonly( NSString *,         uuidForDevice ); // changes only on system reset, this is the best replacement to the good old udid (persistent to device)

- (NSString *)urlSchemaWithName:(NSString *)name;

- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

// 临时写在这里
@prop_readonly( NSString *,            deviceUDID ); // Stored in keychain

/**
 *  Setting page
 */
- (void)openSettings;

/**
 *  WIFI
 */
- (void)openWIFI;

/**
 *  打电话
 *
 *  @param telnum 电话号码
 */
- (BOOL)call:(NSString *)phone;

/** This method retruns the hardware type */
+ (NSString*)hardwareString;

/** This method returns the Hardware enum depending upon harware string */
+ (Hardware)hardware;

/** This method returns the readable description of hardware string */
+ (NSString*)hardwareDescription;

/** This method returns the readable simple description of hardware string */
+ (NSString*)hardwareSimpleDescription;

/**
 This method returns the hardware number not actual but logically.
 e.g. if the hardware string is 5,1 then hardware number would be 5.1
 */
+ (float)hardwareNumber:(Hardware)hardware;

/** This method returns the resolution for still image that can be received
 from back camera of the current device. Resolution returned for image oriented landscape right. **/
+ (CGSize)backCameraStillImageResolutionInPixels;


/** Iphones adapter.**/
+ (void)adaptPhone4s:(Block)phone4sBlock
             phone5s:(Block)phone5sBlock
              phone6:(Block)phone6Block
             phone6p:(Block)phone6pBlock;

/** Ipads adapter. 1024*768 2048*1536 **/
+ (void)adapterPad1024:(Block)pad1024Block
               pad2048:(Block)pad2048Block;

@end
