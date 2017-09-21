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

#import <mach/mach.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "_systeminfo.h"
#import "_foundation.h"

#pragma mark -

/**
 *  @author fallenink
 
 *  About error: @""
 
 *  Initialize in Class Method: @"+ (void)initialize"
 *  or change file suffix from "*.m" to "*.mm"
 */

BOOL IOS8 = NO;
BOOL IOS9 = NO;
BOOL iOS10 = NO;
BOOL iOS11 = NO;

BOOL iOS11_or_later = NO;
BOOL IOS10_OR_LATER = NO;
BOOL IOS9_OR_LATER = NO;
BOOL IOS8_OR_LATER = NO;
BOOL IOS7_OR_LATER = NO;
BOOL IOS6_OR_LATER = NO;
BOOL IOS5_OR_LATER = NO;
BOOL IOS4_OR_LATER = NO;
BOOL IOS3_OR_LATER = NO;

BOOL iOS11_or_earlier = NO;
BOOL IOS9_OR_EARLIER = NO;
BOOL IOS8_OR_EARLIER = NO;
BOOL IOS7_OR_EARLIER = NO;
BOOL IOS6_OR_EARLIER = NO;
BOOL IOS5_OR_EARLIER = NO;
BOOL IOS4_OR_EARLIER = NO;
BOOL IOS3_OR_EARLIER = NO;

BOOL IS_SCREEN_35_INCH = NO;
BOOL IS_SCREEN_4_INCH = NO;
BOOL IS_SCREEN_47_INCH = NO;
BOOL IS_SCREEN_55_INCH = NO;
BOOL is_screen_58_inch = NO;

#pragma mark -

@implementation _SystemInfo {
    // uuids
    NSString *_uuidForSession;
    NSString *_uuidForInstallation;
}

@def_singleton( _SystemInfo );

@def_prop_readonly( NSString *,			osVersion );
@def_prop_readonly( OperationSystem,	osType );
@def_prop_readonly( NSString *,			bundleVersion );
@def_prop_readonly( NSString *,			bundleShortVersion );
@def_prop_readonly( NSString *,			bundleIdentifier );
@def_prop_readonly( NSString *,			urlSchema );
@def_prop_readonly( NSString *,			deviceModel );

@def_prop_readonly( BOOL,				isJailBroken );
@def_prop_readonly( BOOL,				runningOnPhone );
@def_prop_readonly( BOOL,				runningOnPad );
@def_prop_readonly( BOOL,				requiresPhoneOS );

@def_prop_readonly( BOOL,				isScreenPhone );
@def_prop_readonly( BOOL,				isScreen320x480 );
@def_prop_readonly( BOOL,				isScreen640x960 );
@def_prop_readonly( BOOL,				isScreen640x1136 );

@def_prop_readonly( BOOL,				isScreenPad );
@def_prop_readonly( BOOL,				isScreen768x1024 );
@def_prop_readonly( BOOL,				isScreen1536x2048 );

@def_prop_readonly( CGSize,				screenSize );

@def_prop_readonly( double,             totalMemory );
@def_prop_readonly( double,				availableMemory );
@def_prop_readonly( double,				usedMemory );

@def_prop_readonly( double,				availableDisk );

@def_prop_readonly( NSString *,         appSize );

@def_prop_readonly( NSString *,         buildCode );
@def_prop_readonly( int32_t,            intAppVersion );
@def_prop_readonly( NSString *,         appVersion );

@def_prop_readonly( BOOL,               photoCaptureAccessable );
@def_prop_readonly( BOOL,               photoLibraryAccessable );

@def_prop_readonly( NSArray *,          languages );

+ (void)load {
    [self sharedInstance];
    
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    /**
     *  ios 10.0 新方案：
     *
     *  自从前段时间我们放弃了 iOS 7，我们可以轻易的切换到新的 isOperatingSystemAtLeastVersion: 方法上。其内部实现是通过调用 operatingSystemVersion ，是相当高效的
     */
    // 判断当前系统版本
    IOS8 = [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 9.0;
    IOS9 = [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0;
    iOS10 = [[UIDevice currentDevice].systemVersion floatValue] >= 10.0 && [[UIDevice currentDevice].systemVersion floatValue] < 11.0;
    iOS11 = [[UIDevice currentDevice].systemVersion floatValue] >= 11.0 && [[UIDevice currentDevice].systemVersion floatValue] < 12.0;

    iOS11_or_later = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0);
    IOS10_OR_LATER = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0);
    IOS9_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0);
    IOS8_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);
    IOS7_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
    IOS6_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0);
    IOS5_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0);
    IOS4_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0);
    IOS3_OR_LATER =  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0);
    
    iOS11_or_earlier = !iOS11_or_later;
    IOS9_OR_EARLIER = !IOS10_OR_LATER;
    IOS8_OR_EARLIER = !IOS9_OR_LATER;
    IOS7_OR_EARLIER = !IOS8_OR_LATER;
    IOS6_OR_EARLIER = !IOS7_OR_LATER;
    IOS5_OR_EARLIER = !IOS6_OR_LATER;
    IOS4_OR_EARLIER = !IOS5_OR_LATER;
    IOS3_OR_EARLIER = !IOS4_OR_LATER;
    
    IS_SCREEN_4_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
    IS_SCREEN_35_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
    IS_SCREEN_47_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO);
    IS_SCREEN_55_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO);
    is_screen_58_inch = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
#else
    // all NO
#endif
}

- (NSString *)now {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)osVersion {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else
    return nil;
#endif
}

- (OperationSystem)osType {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return OperationSystem_iOS;
#elif (TARGET_OS_MAC)
    return OperationSystem_Mac;
#else
    return OperationSystem_Unknown;
#endif
}

- (NSString *)bundleVersion {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
#else
    return nil;
#endif
}

- (NSString *)bundleShortVersion {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#else
    return nil;
#endif
}

- (NSString *)bundleIdentifier {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#else
    return nil;
#endif
}

- (NSString *)urlSchema {
    return [self urlSchemaWithName:nil];
}

- (NSString *)urlSchemaWithName:(NSString *)name {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array ) {
        if ( name ) {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName ) {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] ) {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count ) {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length ) {
            return schema;
        }
    }
    
    return nil;
    
#else
    
    return nil;
    
#endif
}

- (NSString *)deviceModel {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;
#else
    return nil;
#endif
}

#pragma mark - JailBroken

- (BOOL)isJailBroken {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    static const char * __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    // method 1
    
    for ( int i = 0; __jb_apps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] ) {
            return YES;
        }
    }
    
    // method 2
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        return YES;
    }
    
    // method 3
    
    //#ifdef __IPHONE_8_0
    //
    //	if ( 0 == posix_spawn("ls") )
    //	{
    //		return YES;
    //	}
    //
    //#else
    //
    //	if ( 0 == system("ls") )
    //	{
    //		return YES;
    //	}
    //
    //#endif
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

#pragma mark - Go on

- (BOOL)runningOnPhone {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSString * deviceType = [UIDevice currentDevice].model;
    if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 ) {
        return YES;
    }
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

- (BOOL)runningOnPad {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSString * deviceType = [UIDevice currentDevice].model;
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 ) {
        return YES;
    }
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

- (BOOL)requiresPhoneOS {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
    
#else
    
    return NO;
    
#endif
}

- (BOOL)isScreenPhone {
    if ( [self isScreen320x480] || [self isScreen640x960] || [self isScreen640x1136] || [self isScreen750x1334] || [self isScreen1242x2208] || [self isScreen1125x2001] ) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isScreen320x480 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        if ( [self requiresPhoneOS] && [self isScreen768x1024] ) {
            return YES;
        }
        
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(320, 480)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen640x960 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        if ( [self requiresPhoneOS] && [self isScreen1536x2048] ) {
            return YES;
        }
        
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(640, 960)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen640x1136 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(640, 1136)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen750x1334 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(750, 1334)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1242x2208 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(1242, 2208)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1125x2001 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] ) {
        return NO;
    } else {
        return [self isScreenSizeEqualTo:CGSizeMake(1125, 2001)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenPad {
    if ( [self isScreen768x1024] || [self isScreen1536x2048] ) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isScreen768x1024 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [self isScreenSizeEqualTo:CGSizeMake(768, 1024)];
    
#endif
    
    return NO;
}

- (BOOL)isScreen1536x2048 {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [self isScreenSizeEqualTo:CGSizeMake(1536, 2048)];
    
#endif
    
    return NO;
}

- (CGSize)screenSize {
    return [UIScreen mainScreen].currentMode.size;
}

- (BOOL)isScreenSizeEqualTo:(CGSize)size {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) ) {
        return YES;
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenSizeSmallerThan:(CGSize)size {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( (size.width > screenSize.width && size.height > screenSize.height) ||
        (size2.width > screenSize.width && size2.height > screenSize.height) ) {
        return YES;
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenSizeBiggerThan:(CGSize)size {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( (size.width < screenSize.width && size.height < screenSize.height) ||
        (size2.width < screenSize.width && size2.height < screenSize.height) ) {
        return YES;
    }
    
#endif
    
    return NO;
}

- (BOOL)isOsVersionOrEarlier:(NSString *)ver {
    if ( [[self osVersion] compare:ver] != NSOrderedDescending ) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOsVersionOrLater:(NSString *)ver {
    if ( [[self osVersion] compare:ver] != NSOrderedAscending ) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isOsVersionEqualTo:(NSString *)ver {
    if ( NSOrderedSame == [[self osVersion] compare:ver] ) {
        return YES;
    } else {
        return NO;
    }	
}

#pragma mark - memory

- (double)totalMemory {
    return [[NSProcessInfo processInfo] physicalMemory]/1024.0/1024.0;
}

- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

#pragma mark - Disk

- (double)availableDisk {
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfFileSystemForPath:path_of_document error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

- (NSString *)appSize {
    unsigned long long docSize   =  [self sizeOfFolder:path_of_document];
    unsigned long long libSize   =  [self sizeOfFolder:path_of_library];
    unsigned long long cacheSize =  [self sizeOfFolder:path_of_cache];
    
    unsigned long long total = docSize + libSize + cacheSize;
    
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

- (unsigned long long)sizeOfFolder:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}

#pragma mark -

- (NSString *)buildCode {
    return app_build; // ^_^
}

- (int32_t)intAppVersion {
    NSString *versionStr = app_version;
    NSArray *strVerArr = [versionStr componentsSeparatedByString:@"."];
    NSMutableString *version = [[NSMutableString alloc]init];
    for (int i =0 ; i<strVerArr.count; i++) {
        NSString *str = strVerArr[i];
        if (i == strVerArr.count-1 &&
            str.length == 1) {
            
            str = [NSString stringWithFormat:@"0%@",str];
            [version appendString:str];
        } else {
            [version appendString:str];
        }
    }
    
    return [version intValue];
}

- (NSString *)appVersion {
    return app_version; // ^_^
}

#pragma mark - Accessory

- (BOOL)photoCaptureAccessable {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){// || authStatus == ALAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

- (BOOL)photoLibraryAccessable {
    if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if ((status == PHAuthorizationStatusDenied) || (status == PHAuthorizationStatusRestricted)) {
            return NO;
        } else {
            return YES;
        }
    } else {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ((author == ALAuthorizationStatusDenied) || (author == ALAuthorizationStatusRestricted)) {
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - language

- (NSArray *)languages {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"AppleLanguages"];
}

- (NSString *)currentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages firstObject];
    return [NSString stringWithString:currentLanguage];
}

@end
