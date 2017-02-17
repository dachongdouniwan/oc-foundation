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

// ----------------------------------
// Macros
// ----------------------------------

#pragma mark -

typedef void ( *ImpFuncType )( id a, SEL b, void * c );

#pragma mark -

#undef  joint
#define joint( name )						property (nonatomic, readonly) NSString * __name

#undef  def_joint
#define def_joint( name	)					dynamic __name

#define hookBefore( name, ... )				hookBefore_( macro_concat(before_, name), __VA_ARGS__)
#define hookBefore_( name, ... )			- (void) macro_join(name, __VA_ARGS__)

#define hookAfter( name, ... )				hookAfter_( macro_concat(after_, name), __VA_ARGS__)
#define hookAfter_( name, ... )				- (void) macro_join(name, __VA_ARGS__)

#pragma mark -

#define trigger( target, prefix, name )		[target performCallChainWithPrefix:macro_string(macro_concat(prefix, name)) reversed:NO]
#define triggerR( target, prefix, name )	[target performCallChainWithPrefix:macro_string(macro_concat(prefix, name)) reversed:YES]

#define triggerBefore( target, name )		[target performCallChainWithPrefix:macro_string(macro_concat(before_, name)) reversed:NO]
#define triggerBeforeR( target, name )		[target performCallChainWithPrefix:macro_string(macro_concat(before_, name)) reversed:YES]

#define triggerAfter( target, name )		[target performCallChainWithPrefix:macro_string(macro_concat(after_, name)) reversed:NO]
#define triggerAfterR( target, name )		[target performCallChainWithPrefix:macro_string(macro_concat(after_, name)) reversed:YES]

#define	callChain( target, name )			[target performCallChainWithName:@(#name) reversed:NO]
#define	callChainR( target, name )			[target performCallChainWithName:@(#name) reversed:YES]

// ----------------------------------
// Class code
// ----------------------------------

#pragma mark -

@interface NSObject ( Loader )

- (void)load;
- (void)unload;

- (void)performLoad;
- (void)performUnload;

@end

#pragma mark -

@interface NSObject ( Trigger )

+ (void)performSelectorWithPrefix:(NSString *)prefix;
- (void)performSelectorWithPrefix:(NSString *)prefix;

- (id)performCallChainWithSelector:(SEL)sel;
- (id)performCallChainWithSelector:(SEL)sel reversed:(BOOL)flag;

- (id)performCallChainWithPrefix:(NSString *)prefix;
- (id)performCallChainWithPrefix:(NSString *)prefix reversed:(BOOL)flag;

- (id)performCallChainWithName:(NSString *)name;
- (id)performCallChainWithName:(NSString *)name reversed:(BOOL)flag;

@end
