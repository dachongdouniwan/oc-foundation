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



