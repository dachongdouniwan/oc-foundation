//
//  _device.h
//  student
//
//  Created by fallen.ink on 28/09/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_precompile.h"

typedef NS_ENUM(NSUInteger, Hardware) {
    NOT_AVAILABLE,
    
    IPHONE_2G,
    IPHONE_3G,
    IPHONE_3GS,
    
    IPHONE_4,
    IPHONE_4_CDMA,
    IPHONE_4S,
    
    IPHONE_5,
    IPHONE_5_CDMA_GSM,
    IPHONE_5C,
    IPHONE_5C_CDMA_GSM,
    IPHONE_5S,
    IPHONE_5S_CDMA_GSM,
    
    IPHONE_6,
    IPHONE_6_PLUS,
    IPHONE_6S,
    IPHONE_6S_PLUS,
    
    
    IPOD_TOUCH_1G,
    IPOD_TOUCH_2G,
    IPOD_TOUCH_3G,
    IPOD_TOUCH_4G,
    IPOD_TOUCH_5G,
    
    IPAD,
    IPAD_2,
    IPAD_2_WIFI,
    IPAD_2_CDMA,
    IPAD_3,
    IPAD_3G,
    IPAD_3_WIFI,
    IPAD_3_WIFI_CDMA,
    IPAD_4,
    IPAD_4_WIFI,
    IPAD_4_GSM_CDMA,
    
    IPAD_MINI,
    IPAD_MINI_WIFI,
    IPAD_MINI_WIFI_CDMA,
    IPAD_MINI_RETINA_WIFI,
    IPAD_MINI_RETINA_WIFI_CDMA,
    IPAD_MINI_3_WIFI,
    IPAD_MINI_3_WIFI_CELLULAR,
    IPAD_MINI_RETINA_WIFI_CELLULAR_CN,
    
    IPAD_AIR_WIFI,
    IPAD_AIR_WIFI_GSM,
    IPAD_AIR_WIFI_CDMA,
    IPAD_AIR_2_WIFI,
    IPAD_AIR_2_WIFI_CELLULAR,
    
    SIMULATOR
};

@interface _Device : NSObject

/** This method retruns the hardware type */
+ (NSString*)hardwareString;

/** This method returns the Hardware enum depending upon harware string */
+ (Hardware)hardware;

/** This method returns the readable description of hardware string */
+ (NSString*)hardwareDescription;

/** This method returns the readable simple description of hardware string */
+ (NSString*)hardwareSimpleDescription;

/**
 This method returns the hardware number not actual but logically.
 e.g. if the hardware string is 5,1 then hardware number would be 5.1
 */
+ (float)hardwareNumber:(Hardware)hardware;

/** This method returns the resolution for still image that can be received
 from back camera of the current device. Resolution returned for image oriented landscape right. **/
+ (CGSize)backCameraStillImageResolutionInPixels;


/** Iphones adapter.**/
+ (void)adaptPhone4s:(Block)phone4sBlock
             phone5s:(Block)phone5sBlock
              phone6:(Block)phone6Block
             phone6p:(Block)phone6pBlock;

/** Ipads adapter. 1024*768 2048*1536 **/
+ (void)adapterPad1024:(Block)pad1024Block
               pad2048:(Block)pad2048Block;

@end
