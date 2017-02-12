//
//  _class_loader.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_class_loader.h"

#pragma mark -

@implementation NSObject(ClassLoader)

+ (void)classAutoLoad {
}

@end

#pragma mark -

@implementation _ClassLoader

+ (instancetype)classLoader {
    return [[_ClassLoader alloc] init];
}

- (void)loadClasses:(NSArray *)classNames {
    for (NSString * className in classNames) {
        Class classType = NSClassFromString(className);
        if (classType) {
            fprintf(stderr, "  Loading class '%s'\n", [[classType description] UTF8String]);
            
            NSMethodSignature * signature = [classType methodSignatureForSelector:@selector(classAutoLoad)];
            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation setTarget:classType];
            [invocation setSelector:@selector(classAutoLoad)];
            [invocation invoke];
        }
    }
    
    fprintf( stderr, "\n" );
}

@end
