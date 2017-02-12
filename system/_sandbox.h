//
//  _sandbox.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_precompile.h"
#import "_property.h"
#import "_singleton.h"

#pragma mark -

@interface _Sandbox : NSObject

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

@singleton( _Sandbox )

- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)file;

@end
