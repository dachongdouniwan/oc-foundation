//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/    /__|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
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
