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

#import "NSData+Extension.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (EncDec)

#define CHAR64(c) (index_64[(unsigned char)(c)])

#define BASE64_GETC (length > 0 ? (length--, bytes++, (unsigned int)(bytes[-1])) : (unsigned int)EOF)
#define BASE64_PUTC(c) [buffer appendBytes: &c length: 1]

static char basis_64[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static inline void output64Chunk( int c1, int c2, int c3, int pads, NSMutableData * buffer )
{
    char pad = '=';
    BASE64_PUTC(basis_64[c1 >> 2]);
    BASE64_PUTC(basis_64[((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4)]);
    
    switch ( pads )
    {
        case 2:
            BASE64_PUTC(pad);
            BASE64_PUTC(pad);
            break;
            
        case 1:
            BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
            BASE64_PUTC(pad);
            break;
            
        default:
        case 0:
            BASE64_PUTC(basis_64[((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6)]);
            BASE64_PUTC(basis_64[c3 & 0x3F]);
            break;
    }
}


- (NSString *)string {
    return [[NSString alloc] initWithData:self encoding:NSStringEncodingConversionAllowLossy];
}

- (NSData *)MD5 {
    unsigned char md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_MD5( [self bytes], (CC_LONG)[self length], md5Result );
    
    NSMutableData * retData = [NSMutableData new];
    if ( nil == retData )
        return nil;
    
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    return retData;
}

- (NSString *)MD5String {
    NSData * value = [self MD5];
    if ( value ) {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i ) {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return result;
    } else {
        return nil;
    }
}

- (NSData *)Base64 {
    NSMutableData * buffer = [NSMutableData data];
    const unsigned char * bytes;
    NSUInteger length;
    unsigned int c1, c2, c3;
    
    bytes = [self bytes];
    length = [self length];
    
    while ( (c1 = BASE64_GETC) != (unsigned int)EOF )
    {
        c2 = BASE64_GETC;
        if ( c2 == (unsigned int)EOF )
        {
            output64Chunk( c1, 0, 0, 2, buffer );
        }
        else
        {
            c3 = BASE64_GETC;
            if ( c3 == (unsigned int)EOF )
                output64Chunk( c1, c2, 0, 1, buffer );
            else
                output64Chunk( c1, c2, c3, 0, buffer );
        }
    }
    
    return buffer;
}

- (NSString *)Base64String {
    return [[NSString alloc] initWithData:[self Base64] encoding:NSASCIIStringEncoding];
}

@end

@implementation NSData (Util)

- (void)writeToBinaryFile:(NSString *)path atomically:(BOOL)atomically {
    NSError *error = nil;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    if (error)
        [NSException raise:NSInternalInconsistencyException format:@"%@", error.localizedDescription];
    [data writeToFile:path atomically:atomically];
}

@end


#pragma mark - Encryption

@implementation NSData (Encryption)

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key {
    return [self AES128EncryptedDataWithKey:key iv:nil];
}

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key {
    return [self AES128DecryptedDataWithKey:key iv:nil];
}

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv {
    return [self AES128Operation:kCCEncrypt key:key iv:iv options:kCCOptionPKCS7Padding | kCCOptionECBMode];
}

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv {
    return [self AES128Operation:kCCDecrypt key:key iv:iv options:kCCOptionPKCS7Padding];
}

- (NSData *)AES128DecryptedDataWithKeyData:(NSData *)key ivData:(NSData *)iv {
    return [self AES128Operation:kCCDecrypt keyData:key ivData:iv options:kCCOptionPKCS7Padding];
}

- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv options:(uint32_t)options {
    return [[self pad:0] AES128Operation:operation keyData:[key dataUsingEncoding:NSUTF8StringEncoding] ivData:[iv dataUsingEncoding:NSUTF8StringEncoding] options:options];
}

// kCCModeCBC
- (NSData *)AES128Operation:(CCOperation)operation keyData:(NSData *)key ivData:(NSData *)iv options:(uint32_t)options {
    NSParameterAssert(key);
    
    size_t bufferSize = self.length + kCCKeySizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t decryptedLength = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          options,
                                          key.bytes,
                                          kCCKeySizeAES256,
                                          iv.bytes,
                                          self.bytes,
                                          self.length,
                                          buffer,
                                          bufferSize,
                                          &decryptedLength);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:decryptedLength];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)pad:(NSUInteger)blockSize {
    NSMutableData *data = self.mutableCopy;
    if (blockSize == 0)
        blockSize = 16;
    
    NSUInteger count = (blockSize - (data.length % blockSize)) % blockSize;
    data.length = data.length + count;
    
    return data;
}

@end

#pragma mark - FileFormat
@implementation NSData (FileFormat)

- (BOOL)isJPEG {
    uint8_t a, b, c, d;
    [self getHeader:&a b:&b c:&c d:&d];
    
    return a == 0xFF && b == 0xD8 && c == 0xFF && (d == 0xE0 || d == 0xE1 || d == 0xE8);
}

- (BOOL)isPNG {
    uint8_t a, b, c, d;
    [self getHeader:&a b:&b c:&c d:&d];
    
    return a == 0x89 && b == 0x50 && c == 0x4E && d == 0x47;
}

- (BOOL)isImage {
    return self.isJPEG || self.isPNG;
}

- (BOOL)isMPEG4 {
    uint8_t a, b, c, d;
    [self getBytes:&a range:NSMakeRange(4, 1)];
    [self getBytes:&b range:NSMakeRange(5, 1)];
    [self getBytes:&c range:NSMakeRange(6, 1)];
    [self getBytes:&d range:NSMakeRange(7, 1)];
    
    return a == 0x66 && b == 0x74 && c == 0x79 && d == 0x70;
}

- (BOOL)isMedia {
    return self.isImage || self.isMPEG4;
}

- (BOOL)isCompressed {
    uint8_t a, b, c, d;
    [self getHeader:&a b:&b c:&c d:&d];
    
    // PK header
    return a == 0x50 && b == 0x4B && c == 0x03 && d == 0x04;
}

- (void)getHeader:(void *)a b:(void *)b c:(void *)c d:(void *)d {
    [self getBytes:a length:1];
    [self getBytes:b range:NSMakeRange(1, 1)];
    [self getBytes:c range:NSMakeRange(2, 1)];
    [self getBytes:d range:NSMakeRange(3, 1)];
}

- (NSString *)appropriateFileExtension {
    if (self.isJPEG) return @".jpg";
    if (self.isPNG) return @".png";
    if (self.isMPEG4) return @".mp4";
    if (self.isCompressed) return @".zip";
    return @".dat";
}

@end


#pragma mark - Encoding
@implementation NSData (Encoding)

- (NSString *)MD5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (CC_LONG)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)self.bytes;
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger      dataLength  = self.length;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return hexString;
}

- (NSString *)sha256Hash {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (unsigned int)self.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02x", result[i]];
    
    return hash;
}

@end

