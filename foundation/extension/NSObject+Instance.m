//
//  NSObject+Instance.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "NSObject+Instance.h"

@implementation NSObject (Instance)

+ (instancetype)instance {
    return [self new];
}

@end
