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
// The macro is inspired from:
//     http://stackoverflow.com/questions/3339722/check-iphone-ios-version

/*
 *  System Versioning Preprocessor Macros
 */
#define system_version [UIDevice currentDevice].systemVersion

#define system_version_equal_to( _version_ )  ([[[UIDevice currentDevice] systemVersion] compare:_version_ options:NSNumericSearch] == NSOrderedSame)

#define system_version_greater_than( _version_ )              ([[[UIDevice currentDevice] systemVersion] compare:_version_ options:NSNumericSearch] == NSOrderedDescending)

#define system_version_greater_than_or_equal_to( _version_ )  ([[[UIDevice currentDevice] systemVersion] compare:_version_ options:NSNumericSearch] != NSOrderedAscending)

#define system_version_less_than( _version_ )                 ([[[UIDevice currentDevice] systemVersion] compare:_version_ options:NSNumericSearch] == NSOrderedAscending)

#define system_version_less_than_or_equal_to( _version_ )     ([[[UIDevice currentDevice] systemVersion] compare:_version_ options:NSNumericSearch] != NSOrderedDescending)

/*
   Usage sample:

if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
    ...
}

if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
    ...
}

*/

#define runloop_run_for_a_while \
{ \
[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
}

#define is_iphone_simulator TARGET_IPHONE_SIMULATOR
#define is_iphone_device !TARGET_IPHONE_SIMULATOR

