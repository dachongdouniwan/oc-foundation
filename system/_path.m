//
//  _path.m
//  hairdresser
//
//  Created by fallen.ink on 8/15/16.
//
//

#import "_path.h"
#import "foundation/_foundation.h"

static const NSString *path_service = nil;

@implementation _Path

#pragma mark - Const

+ (NSString *)documentPath {
    return [self flexiableWithBasePath:path_of_document];
}

+ (NSString *)cachePath {
    return [self flexiableWithBasePath:path_of_cache];
}

+ (NSString *)tmpPath {
    return [self flexiableWithBasePath:path_of_temp];
}

#pragma mark - Construct

+ (NSString *)flexiableWithBasePath:(NSString *)path {
    if ([path_service empty]) {
        return path;
    } else {
        return [path stringByAppendingPathComponent:(NSString *)path_service];
    }
}

+ (NSString *)documentPathWithName:(NSString *)name {
    return [[self documentPath] stringByAppendingPathComponent:name];
}

+ (NSString *)cachePathWithName:(NSString *)name {
    return [[self cachePath] stringByAppendingPathComponent:name];
}

+ (NSString *)tmpPathWithName:(NSString *)name {
    return [[self tmpPath] stringByAppendingPathComponent:name];
}

@end

#pragma mark - 

@implementation _Path ( Service )

+ (void)setService:(NSString *)service {
    TODO("后续需要独立出来，用serveID， 这样用注入，反向依赖吧。。。。fallenink")
    path_service = service;
}

@end

