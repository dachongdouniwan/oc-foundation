//
//  NSURL+Extension.h
//  consumer
//
//  Created by fallen.ink on 18/10/2016.
//
//

#import <Foundation/Foundation.h>

#pragma mark -

@interface NSURL ( Extension )

+ (NSURL *)URLWithStringOrNil:(NSString *)URLString;

/*
 * Returns a string of the base of the URL, will contain a trailing slash
 *
 * Example:
 * NSURL is http://www.cnn.com/full/path?query=string&key=value
 * baseString will return: http://www.cnn.com/
 */
- (NSString *)baseString;

@end

#pragma mark -

@interface NSURL ( Comparison )

- (BOOL) isEqualToURL:(NSURL *)otherURL;

@end
