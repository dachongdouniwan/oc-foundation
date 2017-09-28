//
//  _idiot.h
//  student
//
//  Created by fallen.ink on 28/09/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_foundation.h"

#import "_i_application.h"
#import "_i_cache.h"
#import "_i_network.h"
#import "_i_utility.h"

@interface _Idiot : NSObject

@singleton(_Idiot)

@prop_strong(id<_IApplication>, app)

@prop_strong(id<_ICache>, cache)

@prop_strong(id<_INetwork>, net)

@prop_strong(id<_IUtility>, util)

// service

//

@end

#define idiot [_ToolBox sharedInstance]
