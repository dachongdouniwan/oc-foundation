//
//  _namespace.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------
// Macro
// ----------------------------------

#pragma mark -

@class _Namespace;
extern _Namespace * suite;

#pragma mark -

@interface _Namespace : NSObject
@end

#pragma mark -

#define namespace( ... )		macro_concat( namespace_, macro_count(__VA_ARGS__) )( __VA_ARGS__ )
#define namespace_0( ... )
#define namespace_1( _parent, ... ) \
interface _Namespace_##_parent : _Namespace \
@end \
@interface _Namespace (_Namespace_##_parent) \
@prop_readonly( _Namespace_##_parent *, _parent ); \
@end

#define namespace_2( ... )
#define namespace_3( _parent, _child, _class, ... ) \
interface _Namespace_##_parent (_Namespace_##_child) \
@prop_readonly( _class *, _child ); \
@end

#define namespace_4( ... )
#define namespace_5( _parent, _child, _class, _subchild, _subclass, ... ) \
interface _class (_Namespace_##_subchild) \
@prop_readonly( _subclass *, _subchild ); \
@end

#pragma mark -

#define	def_namespace( ... )	macro_concat( def_namespace_, macro_count(__VA_ARGS__) )( __VA_ARGS__ )
#define def_namespace_0( ... )
#define def_namespace_1( _parent, ... ) \
implementation _Namespace_##_parent \
@end \
@implementation _Namespace (_Namespace_##_parent) \
@def_prop_dynamic( _Namespace_##_parent *, _parent ); \
- (_Namespace_##_parent *)_parent { \
static __strong id __instance = nil; \
if ( nil == __instance ) \
{ \
__instance = [[_Namespace_##_parent alloc] init]; \
} \
return __instance; \
} \
@end

#define def_namespace_2( ... )
#define def_namespace_3( _parent, _child, _class, ... ) \
implementation _Namespace_##_parent (_Namespace_##_child) \
@def_prop_dynamic( _class *, _child ); \
- (_class *)_child { \
static __strong id __instance = nil; \
if ( nil == __instance ) \
{ \
if ( [_class respondsToSelector:@selector(sharedInstance)] ) \
{ \
__instance = [_class sharedInstance]; \
} \
else \
{ \
__instance = [[_class alloc] init]; \
} \
} \
return __instance; \
} \
@end

#define def_namespace_4( ... )
#define def_namespace_5( _parent, _child, _class, _subchild, _subclass, ... ) \
implementation _class (_Namespace_##_subchild) \
@def_prop_dynamic( _subclass *, _subchild ); \
- (_subclass *)_subchild { \
static __strong id __instance = nil; \
if ( nil == __instance ) \
{ \
if ( [_class respondsToSelector:@selector(sharedInstance)] ) \
{ \
__instance = [_class sharedInstance]; \
} \
else \
{ \
__instance = [[_class alloc] init]; \
} \
} \
return __instance; \
} \
@end
