//
//  NSBundle+Utility.h
//  component
//
//  Created by Ben on 15/8/5.
//  Copyright (c) 2015年 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define main_bundle [NSBundle mainBundle]
#define image_named_bundled( _imageName_, _bundleName_ ) [NSBundle imageWithName:_imageName_ bundleName:_bundleName_]
#define image_named_bundled_subpath( _imageName_, _bundleName_, _subPath_) [NSBundle imageWithName:_imageName_ bundleName:_bundleName_ subPath:_subPath_]

@interface NSBundle (Extension)

+ (NSBundle *)bundleWithName:(NSString *)bundleName;
+ (UIImage *)imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName;
+ (UIImage *)imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName subPath:(NSString *)subPath;

@end



