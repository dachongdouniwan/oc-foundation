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

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSBundle *)bundleWithName:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (UIImage *)imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName {
    NSBundle *bundle = [self bundleWithName:bundleName];
    UIImage *(^ getBundleImage)(NSString *) = ^(NSString *res) {
        NSString *imagePath = [bundle pathForResource:res ofType:@"png"];
        return  [UIImage imageWithContentsOfFile:imagePath];
    };
    UIImage *image = getBundleImage(imageName);
    
    return image;
}

+ (UIImage *)imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName subPath:(NSString *)subPath {
    NSBundle *bundle = [self bundleWithName:bundleName];
    UIImage *(^ getBundleImage)(NSString *) = ^(NSString *res) {
        NSString *imagePath = [bundle pathForResource:res ofType:@"png" inDirectory:subPath];
        return  [UIImage imageWithContentsOfFile:imagePath];
    };
    UIImage *image = getBundleImage(imageName);
    
    return image;
}

@end
