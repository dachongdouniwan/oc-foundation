//
//  _log.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_vendor_lumberjack.h"
#import "_singleton.h"

/**
 *  CocoaLumerjack 宏定义
 */
#ifdef DEBUG

//#   define ddLogLevel DDLogLevelAll

#   define logv        DDLogVerbose
#   define logd        DDLogDebug
#   define logi        DDLogInfo
#   define logw        DDLogWarn
#   define loge        DDLogError

#else

//#   define ddLogLevel DDLogLevelError

#   define logv(...)
#   define logd(...)
#   define logi(...)
#   define logw(...)
#   define loge(...)

#endif

@interface _Logger : NSObject

@singleton( _Logger )

@end
