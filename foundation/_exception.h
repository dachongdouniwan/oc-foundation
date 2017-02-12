//
//  _exception.h
//  component
//
//  Created by fallen.ink on 4/26/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

// 通用异常定制
#define kExceptionName @"open exception"

#define kExceptionReasonNotImplemented  @"interface not implemented"
#define kExceptionReasonFunctionWrong   @"function incrrect"

#define exceptioning( _reason_ ) exceptioning_1( @"default.exception", _reason_, nil)

#define exceptioning_1( _name_, _reason_, _userInfo_ ) [NSException raise:_name_ format:@"exception.reason(%@).userInfo(%@)", _reason_, _userInfo_];

#pragma mark -

@interface _exception : NSObject

@end
