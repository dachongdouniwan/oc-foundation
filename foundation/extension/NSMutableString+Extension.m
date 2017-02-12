//
//  NSMutableString+Extension.m
//  component
//
//  Created by fallen.ink on 10/30/15.
//  Copyright © 2015 OpenTeam. All rights reserved.
//

#import "NSMutableString+Extension.h"

@implementation NSMutableString (Extension)

- (NSMutableString *)append:(NSString *)string {
    [self appendString:string];
    
    return self;
}

@end
