/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LocaleType_EN,
    LocaleType_ZH,
    
} LocaleType;

@interface NSDateFormatter (Category)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

#pragma mark -

- (NSDateFormatter *)withLocaleType:(LocaleType)type;

- (NSDateFormatter *)withFormat:(NSString *)dateFormat;

@end

#pragma mark - 

@interface NSDateFormatter (ChiSymbols)

/*
 * @return 一 二 三 四 五 六 日
 */
- (NSArray *)chiSingleWeekdaySymbols;

/*
 * @return 周一 周二 周三 周四 周五 周六 周日
 */
- (NSArray *)chiZhouWeekdaySymbols;

/*
 * @return 星期一 星期二 星期三 星期四 星期五  星期六 星期日
 */
- (NSArray *)chiXingQiWeekdaySymbols;

/*
 * @return 礼拜一 礼拜二 礼拜三 礼拜四 礼拜五 礼拜六 礼拜天
 */
- (NSArray *)chiLiBaiWeekdaySymbols;

@end
