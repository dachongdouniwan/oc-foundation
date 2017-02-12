//
//  _sandbox.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_sandbox.h"

#pragma mark -

@implementation _Sandbox

@def_prop_strong( NSString *,	appPath );
@def_prop_strong( NSString *,	docPath );
@def_prop_strong( NSString *,	libPrefPath );
@def_prop_strong( NSString *,	libCachePath );
@def_prop_strong( NSString *,	tmpPath );

@def_singleton( _Sandbox )

+ (void)classAutoLoad
{
    [_Sandbox sharedInstance];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        NSString *	execName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
        NSString *	execPath = [[NSHomeDirectory() stringByAppendingPathComponent:execName] stringByAppendingPathExtension:@"app"];
        
        NSArray *	docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *	libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *	prefPath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
        NSString *	cachePath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        NSString *	tmpPath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
        
        self.appPath = execPath;
        self.docPath = [docPaths objectAtIndex:0];
        self.tmpPath = tmpPath;
        
        self.libPrefPath = prefPath;
        self.libCachePath = cachePath;
        
        [self touch:self.docPath];
        [self touch:self.tmpPath];
        [self touch:self.libPrefPath];
        [self touch:self.libCachePath];
    }
    return self;
}

- (BOOL)touch:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

- (BOOL)touchFile:(NSString *)file
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    
    return YES;
}

@end
