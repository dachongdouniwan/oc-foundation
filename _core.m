//
//  _core.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_core.h"

#pragma mark -

@def_namespace( core )							// suite.core
@def_namespace( core, debugger,	_Debugger )     // suite.core.debugger
@def_namespace( core, logger,	_Logger )		// suite.core.log
@def_namespace( core, system,	_System )		// suite.core.system

#pragma mark -

@interface __ClassLoader_Core : NSObject
@end

@implementation __ClassLoader_Core

+ (void)classAutoLoad {
//    [_Asserter classAutoLoad];
    [_Debugger classAutoLoad];
    [_Logger classAutoLoad];
    [_Sandbox classAutoLoad];
    [_System classAutoLoad];
    [_Validator classAutoLoad];
}

@end
