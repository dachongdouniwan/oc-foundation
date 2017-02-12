//
//  _file.h
//  hairdresser
//
//  Created by fallen.ink on 9/5/16.
//
//

#import <Foundation/Foundation.h>

@interface _File : NSObject

+ (BOOL)createFolder:(NSString *)dint;

+ (void)remove:(NSString *)path;

+ (void)copyFile:(NSString *)src dint:(NSString *)dint;

+ (int)fileLength: (NSString *) path;

+ (BOOL)fileExit:(NSString *)filepath;

+ (float)folderSizeAtPath:(NSString *)folderPath;

@end
