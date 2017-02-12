//
//  _path.h
//  hairdresser
//
//  Created by fallen.ink on 8/15/16.
//
//

#import <Foundation/Foundation.h>

@interface _Path : NSObject

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