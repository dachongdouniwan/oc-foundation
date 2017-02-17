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
#import "_precompile.h"
#import "_property.h"
#import "_singleton.h"

#pragma mark -

@interface _Sandbox : NSObject

@singleton( _Sandbox )

/**
 *  应用目录
 */
@prop_strong( NSString *,	appPath );
/**
 *  文档目录
 */
@prop_strong( NSString *,	docPath );
@prop_strong( NSString *,	libPrefPath );
@prop_strong( NSString *,	libCachePath );
@prop_strong( NSString *,	tmpPath );

- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)file;

@end

#pragma mark - 

@interface _Path : NSObject // fallenink: 要整合到sandbox

#pragma mark - Const

+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)tmpPath;

#pragma mark - Construct

+ (NSString *)documentPathWithName:(NSString *)name;
+ (NSString *)cachePathWithName:(NSString *)name;
+ (NSString *)tmpPathWithName:(NSString *)name;

@end

#pragma mark -

@interface _Path ( Service )

/**
 *  Importantly
 
 *  service as UserId, uuid
 */
+ (void)setService:(NSString *)service;

@end

#pragma mark - 

@interface _File : NSObject

+ (BOOL)createFolder:(NSString *)dint;

+ (void)remove:(NSString *)path;

+ (void)copyFile:(NSString *)src dint:(NSString *)dint;

+ (int)fileLength: (NSString *) path;

+ (BOOL)fileExit:(NSString *)filepath;

+ (float)folderSizeAtPath:(NSString *)folderPath;

@end
