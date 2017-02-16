//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/     \_|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
//

#import "_swizzler.h"

#if TARGET_OS_IPHONE
	#import <objc/runtime.h>
	#import <objc/message.h>
#else
	#import <objc/objc-class.h>
#endif

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)	\
	if (ERROR_VAR) {	\
		NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
		*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
										 code:-1	\
									 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
	}
#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

#if OBJC_API_VERSION >= 2
#define GetClass(obj)	object_getClass(obj)
#else
#define GetClass(obj)	(obj ? obj->isa : Nil)
#endif

// ----------------------------------
// Source code
// ----------------------------------

@implementation NSObject ( Swizzle )

#pragma mark - Swizzle method

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_ {
	Method origMethod = class_getInstanceMethod(self, origSel_);
	if (!origMethod) {
		SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self class]);
		return NO;
	}
	
	Method altMethod = class_getInstanceMethod(self, altSel_);
	if (!altMethod) {
		SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [self class]);
		return NO;
	}
	
	class_addMethod(self,
					origSel_,
					class_getMethodImplementation(self, origSel_),
					method_getTypeEncoding(origMethod));
	class_addMethod(self,
					altSel_,
					class_getMethodImplementation(self, altSel_),
					method_getTypeEncoding(altMethod));
	
	method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
	return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_ {
	return [GetClass((id)self) swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

#pragma mark - Copy method

+ (BOOL)copyMethod:(SEL)origSel_ toMethod:(SEL)dstSel_ error:(NSError *__autoreleasing *)error_ {
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self class]);
        return NO;
    }
    
    Method dstMethod = class_getInstanceMethod(self, dstSel_);
    if (!dstMethod) {
        SetNSError(error_, @"destination method %@ not found for class %@", NSStringFromSelector(dstSel_), [self class]);
        return NO;
    }

    class_addMethod(self,
                    dstSel_,
                    class_getMethodImplementation(self, dstSel_),
                    method_getTypeEncoding(dstMethod));
    
    method_setImplementation(class_getInstanceMethod(self, dstSel_), class_getMethodImplementation(self, origSel_));
    
    return YES;
}

+ (BOOL)copyClassMethod:(SEL)origSel_ toClassMethod:(SEL)dstSel_ error:(NSError *__autoreleasing *)error_ {
    return [GetClass((id)self) copyMethod:origSel_ toMethod:dstSel_ error:error_];
}

@end
