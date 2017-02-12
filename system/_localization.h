//
//  _localization.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _Localization : NSObject

@end

#pragma mark - 

/**
*  @desc localizable string
*/
#define localized(...) [NSString localizedStringWithArgs:__VA_ARGS__]

@interface NSString (Localizable)

+ (NSString *)localizedStringWithArgs:(NSString *)fmt, ...;

@end
