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

#import "_preheaders.h"
#import "_trigger.h"
#import "_pragma_push.h"
#import "NSMutableArray+Extension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject ( Loader )

- (void)load {
}

- (void)unload {
}

- (void)performLoad {
    [self performCallChainWithPrefix:@"before_load" reversed:NO];
    [self performCallChainWithSelector:@selector(load) reversed:NO];
    [self performCallChainWithPrefix:@"after_load" reversed:NO];
}

- (void)performUnload {
    [self performCallChainWithPrefix:@"before_unload" reversed:YES];
    [self performCallChainWithSelector:@selector(unload) reversed:YES];
    [self performCallChainWithPrefix:@"after_unload" reversed:YES];
}

@end

#pragma mark -

@implementation NSObject(Trigger)

+ (void)performSelectorWithPrefix:(NSString *)prefixName
{
    unsigned int	methodCount = 0;
    Method *		methodList = class_copyMethodList( self, &methodCount );
    
    if ( methodList && methodCount )
    {
        for ( NSUInteger i = 0; i < methodCount; ++i )
        {
            SEL sel = method_getName( methodList[i] );
            
            const char * name = sel_getName( sel );
            const char * prefix = [prefixName UTF8String];
            
            if ( 0 == strcmp(prefix, name) )
            {
                continue;
            }
            
            if ( 0 == strncmp( name, prefix, strlen(prefix) ) )
            {
                ImpFuncType imp = (ImpFuncType)method_getImplementation( methodList[i] );
                if ( imp )
                {
                    imp( self, sel, nil );
                }
            }
        }
    }
    
    free( methodList );
}

- (void)performSelectorWithPrefix:(NSString *)prefixName
{
    unsigned int	methodCount = 0;
    Method *		methodList = class_copyMethodList( [self class], &methodCount );
    
    if ( methodList && methodCount )
    {
        for ( NSUInteger i = 0; i < methodCount; ++i )
        {
            SEL sel = method_getName( methodList[i] );
            
            const char * name = sel_getName( sel );
            const char * prefix = [prefixName UTF8String];
            
            if ( 0 == strcmp( prefix, name ) )
            {
                continue;
            }
            
            if ( 0 == strncmp( name, prefix, strlen(prefix) ) )
            {
                ImpFuncType imp = (ImpFuncType)method_getImplementation( methodList[i] );
                if ( imp )
                {
                    imp( self, sel, nil );
                }
            }
        }
    }
    
    free( methodList );
}

- (id)performCallChainWithSelector:(SEL)sel
{
    return [self performCallChainWithSelector:sel reversed:NO];
}

- (id)performCallChainWithSelector:(SEL)sel reversed:(BOOL)flag
{
    NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        if ( flag )
        {
            [classStack addObject:thisClass];
        }
        else
        {
            [classStack insertObject:thisClass atIndex:0];
        }
    }
    
    ImpFuncType prevImp = NULL;
    
    for ( Class thisClass in classStack )
    {
        Method method = class_getInstanceMethod( thisClass, sel );
        if ( method )
        {
            ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
            if ( imp )
            {
                if ( imp == prevImp )
                {
                    continue;
                }
                
                imp( self, sel, nil );
                
                prevImp = imp;
            }
        }
    }
    
    return self;
}

- (id)performCallChainWithPrefix:(NSString *)prefix
{
    return [self performCallChainWithPrefix:prefix reversed:YES];
}

- (id)performCallChainWithPrefix:(NSString *)prefixName reversed:(BOOL)flag
{
    NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        if ( flag )
        {
            [classStack addObject:thisClass];
        }
        else
        {
            [classStack insertObject:thisClass atIndex:0];
        }
    }
    
    for ( Class thisClass in classStack )
    {
        unsigned int	methodCount = 0;
        Method *		methodList = class_copyMethodList( thisClass, &methodCount );
        
        if ( methodList && methodCount )
        {
            for ( NSUInteger i = 0; i < methodCount; ++i )
            {
                SEL sel = method_getName( methodList[i] );
                
                const char * name = sel_getName( sel );
                const char * prefix = [prefixName UTF8String];
                
                if ( 0 == strcmp( prefix, name ) )
                {
                    continue;
                }
                
                if ( 0 == strncmp( name, prefix, strlen(prefix) ) )
                {
                    ImpFuncType imp = (ImpFuncType)method_getImplementation( methodList[i] );
                    if ( imp )
                    {
                        imp( self, sel, nil );
                    }
                }
            }
        }
        
        free( methodList );
    }
    
    return self;
}

- (id)performCallChainWithName:(NSString *)name
{
    return [self performCallChainWithName:name reversed:NO];
}

- (id)performCallChainWithName:(NSString *)name reversed:(BOOL)flag
{
    SEL selector = NSSelectorFromString( name );
    if ( selector )
    {
        NSString * prefix1 = [NSString stringWithFormat:@"before_%@", name];
        NSString * prefix2 = [NSString stringWithFormat:@"after_%@", name];
        
        [self performCallChainWithPrefix:prefix1 reversed:flag];
        [self performCallChainWithSelector:selector reversed:flag];
        [self performCallChainWithPrefix:prefix2 reversed:flag];
    }
    return self;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Object )
{
}

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __TESTING__

#import "_pragma_pop.h"

//#endif
