//
//  NSObject+Instance.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

// NSObject has +instance method
// 实例属性，而非类方法
#undef  prop_instance
#define prop_instance( __type, __name ) \
property (nonatomic, strong) __type * __name;

#undef  def_prop_instance
#define def_prop_instance( __type, __name ) \
synthesize __name; \
- (__type *)__name { \
/* _##__name */if (!__name) { \
__name = [__type instance]; \
} \
\
return __name; \
}

#pragma mark - 

@interface NSObject (Instance)

+ (instancetype)instance;

@end
