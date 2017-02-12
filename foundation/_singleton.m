//
//  _singleton.m
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_singleton.h"

#pragma mark -

@implementation _Singleton

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

@end
