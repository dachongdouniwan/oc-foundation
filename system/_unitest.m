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

#import "_precompile.h"
#import "_unitest.h"
#import "_pragma_push.h"
#import "_runtime.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_UNITTEST_LOGS
#define	MAX_UNITTEST_LOGS	(100)

#pragma mark -

@implementation _TestFailure

@def_prop_strong( NSString *,	expr );
@def_prop_strong( NSString *,	file );
@def_prop_assign( NSInteger,	line );

+ (_TestFailure *)expr:(const char *)expr file:(const char *)file line:(int)line
{
    _TestFailure * failure = [[_TestFailure alloc] initWithName:@"UnitTest" reason:nil userInfo:nil];
    failure.expr = @(expr);
    failure.file = [@(file) lastPathComponent];
    failure.line = line;
    return failure;
}

@end

#pragma mark -

@implementation _TestCase
@end

#pragma mark -

@implementation _UnitTest {
    __strong NSMutableArray * _logs;
}

@def_singleton( _UnitTest )

@def_prop_assign( NSUInteger,	failedCount );
@def_prop_assign( NSUInteger,	succeedCount );

- (id)init {
    if ( self = [super init] ) {
        _logs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    _logs = nil;
}

- (void)run {
    fprintf( stderr, "  =============================================================\n" );
    fprintf( stderr, "   Unit testing ...\n" );
    fprintf( stderr, "  -------------------------------------------------------------\n" );
    
    NSArray *	classes = [_TestCase subClasses];
    LogLevel	filter = [_Logger sharedInstance].filter;
    
    [_Logger sharedInstance].filter = LogLevel_Warn;
    //	[SamuraiLogger sharedInstance].filter = LogLevel_All;
    
    CFTimeInterval beginTime = CACurrentMediaTime();
    
    for ( NSString * className in classes ) {
        Class classType = NSClassFromString( className );
        
        if ( nil == classType )
            continue;
        
        NSString * testCaseName;
        testCaseName = [classType description];
        testCaseName = [testCaseName stringByReplacingOccurrencesOfString:@"__TestCase__" withString:@"  TEST_CASE( "];
        testCaseName = [testCaseName stringByAppendingString:@" )"];
        
        NSString * formattedName = [testCaseName stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
        
        //		[[SamuraiLogger sharedInstance] disable];
        
        fprintf( stderr, "%s", [formattedName UTF8String] );
        
        CFTimeInterval time1 = CACurrentMediaTime();
        
        BOOL testCasePassed = YES;
        
        //	@autoreleasepool
        {
            @try {
                _TestCase * testCase = [[classType alloc] init];
                
                NSArray * selectorNames = [classType methodsWithPrefix:@"runTest_" untilClass:[_TestCase class]];
                
                if ( selectorNames && [selectorNames count] ) {
                    for ( NSString * selectorName in selectorNames ) {
                        SEL selector = NSSelectorFromString( selectorName );
                        
                        if ( selector && [testCase respondsToSelector:selector] ) {
                            NSMethodSignature * signature = [testCase methodSignatureForSelector:selector];
                            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                            
                            [invocation setTarget:testCase];
                            [invocation setSelector:selector];
                            [invocation invoke];
                        }
                    }
                }
            } @catch ( NSException * e ) {
                if ( [e isKindOfClass:[_TestFailure class]] ) {
                    _TestFailure * failure = (_TestFailure *)e;
                    
                    [self writeLog:
                     @"                        \n"
                     "    %@ (#%lu)           \n"
                     "                        \n"
                     "    {                   \n"
                     "        EXPECTED( %@ ); \n"
                     "                  ^^^^^^          \n"
                     "                  Assertion failed\n"
                     "    }                   \n"
                     "                        \n", failure.file, failure.line, failure.expr];
                } else {
                    [self writeLog:@"\nUnknown exception '%@'", e.reason];
                    [self writeLog:@"%@", e.callStackSymbols];
                }
                
                testCasePassed = NO;
            } @finally {
            }
        };
        
        CFTimeInterval time2 = CACurrentMediaTime();
        CFTimeInterval time = time2 - time1;
        
        //		[[SamuraiLogger sharedInstance] enable];
        
        if ( testCasePassed ) {
            _succeedCount += 1;
            
            fprintf( stderr, "[ OK ]   %.003fs\n", time );
        } else {
            _failedCount += 1;
            
            fprintf( stderr, "[FAIL]   %.003fs\n", time );
        }
        
        [self flushLog];
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    float passRate = (_succeedCount * 1.0f) / ((_succeedCount + _failedCount) * 1.0f) * 100.0f;
    
    fprintf( stderr, "  -------------------------------------------------------------\n" );
    fprintf( stderr, "  Total %lu cases                               [%.0f%%]   %.003fs\n", (unsigned long)[classes count], passRate, totalTime );
    fprintf( stderr, "  =============================================================\n" );
    fprintf( stderr, "\n" );
    
    [_Logger sharedInstance].filter = filter;
}

- (void)writeLog:(NSString *)format, ... {
    if ( _logs.count >= MAX_UNITTEST_LOGS ) {
        return;
    }
    
    if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
        return;
    
    va_list args;
    va_start( args, format );
    
    @autoreleasepool
    {
        NSMutableString * content = [[NSMutableString alloc] initWithFormat:(NSString *)format arguments:args];
        [_logs addObject:content];
    };
    
    va_end( args );
}

- (void)flushLog
{
    if ( _logs.count )
    {
        for ( NSString * log in _logs )
        {
            fprintf( stderr, "       %s\n", [log UTF8String] );
        }
        
        if ( _logs.count >= MAX_UNITTEST_LOGS )
        {
            fprintf( stderr, "       ...\n" );
        }
        
        fprintf( stderr, "\n" );
    }
    
    [_logs removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __TESTING__

TEST_CASE( Core, UnitTest )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
