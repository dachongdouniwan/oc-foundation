//
//  _namespace.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_namespace.h"

#pragma mark -

__strong _Namespace * suite = nil;

#pragma mark -

@implementation _Namespace

+ (void)classAutoLoad {
    suite = [[_Namespace alloc] init];
}

@end
