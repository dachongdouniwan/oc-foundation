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

#pragma mark -

@class _Handler;

@interface NSObject ( BlockHandler )

- (_Handler *)blockHandlerOrCreate;
- (_Handler *)blockHandler;

- (void)addBlock:(id)block forName:(NSString *)name;
- (void)removeBlockForName:(NSString *)name;
- (void)removeAllBlocks;

@end

#pragma mark -

@interface _Handler : NSObject

- (BOOL)trigger:(NSString *)name;
- (BOOL)trigger:(NSString *)name withObject:(id)object;

- (void)addHandler:(id)handler forName:(NSString *)name;
- (void)removeHandlerForName:(NSString *)name;
- (void)removeAllHandlers;

@end
