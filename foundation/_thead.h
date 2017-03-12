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
#import "_property.h"
#import "_singleton.h"

// ----------------------------------
// Macros
// ----------------------------------

#pragma mark -

/**
 *  Inserts code that executes a block only once, regardless of how many times the macro is invoked.
 *
 *  @param block The block to execute once.
 */
#ifndef execute_once
#define execute_once( _block_ ) \
        { \
            static dispatch_once_t predicate = 0; \
            dispatch_once(&predicate, _block_); \
        }
#endif

#pragma mark -

// main

#undef  dispatch_async_foreground
#define dispatch_async_foreground( block ) \
        dispatch_async( dispatch_get_main_queue(), block )

#undef  dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), dispatch_get_main_queue(), block ); \

#undef  dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
        dispatch_barrier_async( [_Queue sharedInstance].concurrent, ^{ \
            dispatch_async_foreground( block ); \
        });

// concurrent

#undef  dispatch_async_background_concurrent
#define dispatch_async_background_concurrent( block ) \
        dispatch_async( [_Queue sharedInstance].concurrent, block )

#undef  dispatch_after_background_concurrent
#define dispatch_after_background_concurrent( seconds, block ) \
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), [_Queue sharedInstance].concurrent, block ); \

#undef  dispatch_barrier_async_background_concurrent
#define dispatch_barrier_async_background_concurrent( seconds, block ) \
        dispatch_barrier_async( [_Queue sharedInstance].concurrent, block )

// serial

#undef  dispatch_async_background_serial
#define dispatch_async_background_serial( block ) \
        dispatch_async( [_Queue sharedInstance].serial, block )

#undef  dispatch_after_background_serial
#define dispatch_after_background_serial( seconds, block ) \
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), [_Queue sharedInstance].serial, block ); \

// ----------------------------------
// Class code
// ----------------------------------

#pragma mark -

@interface GCDGroup : NSObject

/**
 *  Returns the underlying dispatch group object.
 *
 *  @return The dispatch group object.
 */
@property (strong, readonly, nonatomic) dispatch_group_t dispatchGroup;

/**
 *  Initializes a new group.
 *
 *  @return The initialized instance.
 *  @see dispatch_group_create()
 */
- (instancetype)init;

/**
 *  The GCDGroup designated initializer.
 *
 *  @param dispatchGroup A dispatch_group_t object.
 *  @return The initialized instance.
 */
- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup;

/**
 *  Explicitly indicates that a block has entered the group.
 *
 *  @see dispatch_group_enter()
 */
- (void)enter;

/**
 *  Explicitly indicates that a block in the group has completed.
 *
 *  @see dispatch_group_leave()
 */
- (void)leave;

/**
 *  Waits forever for the previously submitted blocks in the group to complete.
 *
 *  @see dispatch_group_wait()
 */
- (void)wait;

/**
 *  Waits for the previously submitted blocks in the group to complete.
 *
 *  @param seconds The time to wait in seconds.
 *  @return YES if all blocks completed, NO if the timeout occurred.
 *  @see dispatch_group_wait()
 */
- (BOOL)wait:(double)seconds;

@end

#pragma mark -

@interface GCDSemaphore : NSObject

/**
 *  Returns the underlying dispatch semaphore object.
 *
 *  @return The dispatch semaphore object.
 */
@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

/**
 *  Initializes a new semaphore with starting value 0.
 *
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)init;

/**
 *  Initializes a new semaphore.
 *
 *  @param value The starting value for the semaphore.
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)initWithValue:(long)value;

/**
 *  The GCDSemaphore designated initializer.
 *
 *  @param dispatchSemaphore A dispatch_semaphore_t object.
 *  @return The initialized instance.
 *  @see dispatch_semaphore_create()
 */
- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore;

/**
 *  Signals (increments) the semaphore.
 *
 *  @return YES if a thread is awoken, NO otherwise.
 *  @see dispatch_semaphore_signal()
 */
- (BOOL)signal;

/**
 *  Waits forever for (decrements) the semaphore.
 *
 *  @see dispatch_semaphore_wait()
 */
- (void)wait;

/**
 *  Waits for (decrements) the semaphore.
 *
 *  @param seconds The time to wait in seconds.
 *  @return YES on success, NO if the timeout occurred.
 *  @see dispatch_semaphore_wait()
 */
- (BOOL)wait:(double)seconds;

@end


#pragma mark -

@interface _Queue : NSObject

@singleton( _Queue )

@prop_readonly( dispatch_queue_t,	serial );
@prop_readonly( dispatch_queue_t,	concurrent );

+ (_Queue *)main;
+ (_Queue *)global;
+ (_Queue *)highPriorityGlobal;
+ (_Queue *)lowPriorityGlobal;
+ (_Queue *)backgroundPriorityGlobal;

/**
 *  Submits a block for asynchronous execution on the queue.
 *
 *  @param block The block to submit.
 *  @see dispatch_async()
 */
- (void)queueBlock:(dispatch_block_t)block;

/**
 *  Submits a block for asynchronous execution on the queue after a delay.
 *
 *  @param block The block to submit.
 *  @param seconds The delay in seconds.
 *  @see dispatch_after()
 */
- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds;

/**
 *  Submits a block for execution on the queue and waits until it completes.
 *
 *  @param block The block to submit.
 *  @see dispatch_sync()
 */
- (void)queueAndAwaitBlock:(dispatch_block_t)block;

/**
 *  Submits a block for execution on the queue multiple times and waits until all executions complete.
 *
 *  @param block The block to submit.
 *  @param count The number of times to execute the block.
 *  @see dispatch_apply()
 */
- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count;

/**
 *  Submits a block for asynchronous execution on the queue and associates it with the group.
 *
 *  @param block The block to submit.
 *  @param group The group to associate the block with.
 *  @see dispatch_group_async()
 */
- (void)queueBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

/**
 *  Schedules a block to be submitted to the queue when a group of previously submitted blocks have completed.
 *
 *  @param block The block to submit when the group completes.
 *  @param group The group to observe.
 *  @see dispatch_group_notify()
 */
- (void)queueNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

/**
 *  Submits a barrier block for asynchronous execution on the queue.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_async()
 */
- (void)queueBarrierBlock:(dispatch_block_t)block;

/**
 *  Submits a barrier block for execution on the queue and waits until it completes.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_sync()
 */
- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block;

/**
 *  Suspends execution of blocks on the queue.
 *
 *  @see dispatch_suspend()
 */
- (void)suspend;

/**
 *  Resumes execution of blocks on the queue.
 *
 *  @see dispatch_resume()
 */
- (void)resume;

/**
 *  FA
 
 *  completion is on mainQueue
 */
- (void)queueBlock:(Block)block completion:(Block)completion;

@end

#ifndef main_queue
#define main_queue [_Queue  main]
#endif

#ifndef global_queue
#define global_queue [_Queue global]
#endif

