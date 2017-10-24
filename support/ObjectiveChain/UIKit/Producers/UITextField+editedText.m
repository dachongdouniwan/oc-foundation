//
//  UITextField+editedText.m
//  Objective-Chain
//
//  Created by Martin Kiss on 6.5.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <objc/runtime.h>
#import "_oca_swizzling.h"
#import "UITextField+editedText.h"
#import "_oca_targetter.h"
#import "_oca_property.h"
#import "_oca_hub.h"





@implementation UITextField (editedText)




+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(initWithFrame:)
                         with:@selector(initWithFrame_oca:)];
    });
}


//! Method should begin with “init”, so ARC understands the semantics.
- (instancetype)initWithFrame_oca:(CGRect)frame {
    self = [self initWithFrame_oca:frame];
    if (self) {
        
        OCAWeakify(self);
        
        [[OCAHub merge:
          [self producerForEvent:UIControlEventEditingChanged],
          OCAProperty(self, text, NSString),
          nil] subscribe:^{
            OCAStrongify(self);
            
            self.editedText = self.text;
        }];
    }
    return self;
}


- (NSString *)editedText {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setEditedText:(NSString *)editedText {
    objc_setAssociatedObject(self, @selector(editedText), editedText, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if ( ! OCAEqual(editedText, self.text)) {
        self.text = editedText;
    }
}





@end


