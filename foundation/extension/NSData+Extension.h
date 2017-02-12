//
//  NSData+Extension.h
//  consumer
//
//  Created by fallen.ink on 18/10/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSData (EncDec)

@property (nonatomic, readonly) NSString *	string;

@property (nonatomic, readonly) NSData *	MD5;
@property (nonatomic, readonly) NSString *	MD5String;

@property (nonatomic, readonly) NSData *    Base64;
@property (nonatomic, readonly) NSString *  Base64String;

@end

@interface NSData (Util)

- (void)writeToBinaryFile:(NSString *)path atomically:(BOOL)atomically;

@end


@interface NSData (AES)

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

/** Pads data using PKCS5. blockSize defaults to 16 if given 0. */
- (NSData *)pad:(NSUInteger)blockSize;

@end


@interface NSData (FileFormat)

- (BOOL)isJPEG;
- (BOOL)isPNG;
- (BOOL)isImage;
- (BOOL)isMPEG4;
- (BOOL)isMedia;
- (BOOL)isCompressed;
- (NSString *)appropriateFileExtension;

@end


@interface NSData (Encoding)

- (NSString *)MD5Hash;
- (NSString *)hexadecimalString;
- (NSString *)sha256Hash;

@end

