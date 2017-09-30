#import "_chainable.h"

@implementation _Chainable

- (ChainableView)addToSuperview {
    __weak _Chainable *weakSelf = self;
    return ChainableView(view) {
        [view addSubview:weakSelf.view];
        return weakSelf;
    };
}

#pragma mark - Color

- (ChainableColor)backgroundColor {
    __weak _Chainable *weakSelf = self;
    return ChainableColor(color) {
        weakSelf.view.backgroundColor = color;
        return weakSelf;
    };
}

- (ChainableColor)tintColor {
    __weak _Chainable *weakSelf = self;
    return ChainableColor(color) {
        weakSelf.view.tintColor = color;
        return weakSelf;
    };
}


#pragma mark - Position

- (ChainableRect)frame {
    __weak _Chainable *weakSelf = self;
    return ChainableRect(x, y, width, height) {
        weakSelf.view.frame = CGRectMake(x, y, width, height);
        return weakSelf;
    };
}

- (ChainableRect)bounds {
    __weak _Chainable *weakSelf = self;
    return ChainableRect(x, y, width, height) {
        weakSelf.view.bounds = CGRectMake(x, y, width, height);
        return weakSelf;
    };
}

- (ChainablePoint)origin {
    __weak _Chainable *weakSelf = self;
    return ChainablePoint(x, y) {
        weakSelf.view.frame = CGRectMake(x,
                                         y,
                                         weakSelf.view.frame.size.width,
                                         weakSelf.view.frame.size.height);
        return weakSelf;
    };
}

- (ChainableSize)size {
    __weak _Chainable *weakSelf = self;
    return ChainableSize(width, height) {
        weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x,
                                         weakSelf.view.frame.origin.y,
                                         width,
                                         height);
        return weakSelf;
    };
}

- (ChainablePoint)center {
    __weak _Chainable *weakSelf = self;
    return ChainablePoint(x, y) {
        weakSelf.view.center = CGPointMake(x, y);
        return weakSelf;
    };
}

- (ChainableFloat)x {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(x) {
        weakSelf.view.frame = CGRectMake(x,
                                         weakSelf.view.frame.origin.y,
                                         weakSelf.view.frame.size.width,
                                         weakSelf.view.frame.size.height);
        return weakSelf;
    };
}

- (ChainableFloat)y {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(y) {
        weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x,
                                         y,
                                         weakSelf.view.frame.size.width,
                                         weakSelf.view.frame.size.height);
        return weakSelf;
    };
}
- (ChainableFloat)width {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(width) {
        weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x,
                                         weakSelf.view.frame.origin.y,
                                         width,
                                         weakSelf.view.frame.size.height);
        return weakSelf;
    };
}

- (ChainableFloat)height {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(height) {
        weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x,
                                         weakSelf.view.frame.origin.y,
                                         weakSelf.view.frame.size.width,
                                         height);
        return weakSelf;
    };
}

- (ChainableFloat)centerX {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(centerX) {
        weakSelf.view.center = CGPointMake(centerX,
                                           weakSelf.view.center.y);
        return weakSelf;
    };
}

- (ChainableFloat)centerY {
    __weak _Chainable *weakSelf = self;
    return ChainableFloat(centerY) {
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x,
                                           centerY);
        return weakSelf;
    };
}

@end


/** 添加 UILable 分类 */
@implementation _Chainable (UILabel)

#pragma mark - UILabel

- (ChainableString)text {
    __weak _Chainable *weakSelf = self;
    return ChainableString(text) {
        if ([weakSelf.view respondsToSelector:@selector(text)])
            ((UILabel*)(weakSelf.view)).text = text;
        return weakSelf;
    };
}

- (ChainableFont)font {
    __weak _Chainable *weakSelf = self;
    return ChainableFont(font) {
        if ([weakSelf.view respondsToSelector:@selector(font)])
            ((UILabel*)(weakSelf.view)).font = font;
        return weakSelf;
    };
}

- (ChainableColor)textColor {
    __weak _Chainable *weakSelf = self;
    return ChainableColor(textColor) {
        if ([weakSelf.view respondsToSelector:@selector(textColor)])
            ((UILabel*)(weakSelf.view)).textColor = textColor;
        return weakSelf;
    };
}

- (ChainableInteger)numberOfLines {
    __weak _Chainable *weakSelf = self;
    return ChainableInteger(numberOfLines) {
        if ([weakSelf.view respondsToSelector:@selector(numberOfLines)])
            ((UILabel*)(weakSelf.view)).numberOfLines = numberOfLines;
        return weakSelf;
    };
}

- (ChainableColor)shadowColor {
    __weak _Chainable *weakSelf = self;
    return ChainableColor(shadowColor) {
        if ([weakSelf.view respondsToSelector:@selector(shadowColor)])
            ((UILabel*)(weakSelf.view)).shadowColor = shadowColor;
        return weakSelf;
    };
}

- (ChainableInteger)textAlignment {
    __weak _Chainable *weakSelf = self;
    return ChainableInteger(textAlignment) {
        if ([weakSelf.view respondsToSelector:@selector(textAlignment)])
            ((UILabel*)(weakSelf.view)).textAlignment = textAlignment;
        return weakSelf;
    };
}

- (ChainableInteger)lineBreakMode {
    __weak _Chainable *weakSelf = self;
    return ChainableInteger(lineBreakMode) {
        if ([weakSelf.view respondsToSelector:@selector(lineBreakMode)])
            ((UILabel*)(weakSelf.view)).lineBreakMode = lineBreakMode;
        return weakSelf;
    };
}

- (ChainableAttributedString)attributedText {
    __weak _Chainable *weakSelf = self;
    return ChainableAttributedString(attributedText) {
        if ([weakSelf.view respondsToSelector:@selector(attributedText)])
            ((UILabel*)(weakSelf.view)).attributedText = attributedText;
        return weakSelf;
    };
}

@end


/** 添加 UITextField 分类 */
@implementation _Chainable (UITextField)

- (ChainableString)text{
    __weak _Chainable *weakSelf = self;
    return ChainableString(text){
        if ([weakSelf.view respondsToSelector:@selector(text)])
            ((UITextField *)(weakSelf.view)).text=text;
            return weakSelf;
    };
}

- (ChainableColor)textColor{
    __weak _Chainable *weakSelf = self;
    return ChainableColor(textColor){
        if ([weakSelf.view respondsToSelector:@selector(textColor)])
            ((UITextField *)(weakSelf.view)).textColor=textColor;
        return weakSelf;
    };
}
- (ChainableFont)font{
    __weak _Chainable *weakSelf = self;
    return ChainableFont(font){
        if ([weakSelf.view respondsToSelector:@selector(font)])
            ((UITextField *)(weakSelf.view)).font=font;
        return weakSelf;
    };
}
- (ChainableInteger)textAlignment{
    __weak _Chainable *weakSelf = self;
    return ChainableInteger(textAlignment){
        if ([weakSelf.view respondsToSelector:@selector(textAlignment)])
            ((UITextField *)(weakSelf.view)).textAlignment=textAlignment;
        return weakSelf;
    };
}
- (ChainableString)placeholder{
    __weak _Chainable *weakSelf = self;
    return ChainableString(placeholder){
        if ([weakSelf.view respondsToSelector:@selector(placeholder)])
            ((UITextField *)(weakSelf.view)).placeholder=placeholder;
        return weakSelf;
    };
}
- (ChainableInteger)borderStyle{
    __weak _Chainable *weakSelf = self;
    return ChainableInteger(borderStyle){
        if ([weakSelf.view respondsToSelector:@selector(borderStyle)])
            ((UITextField *)(weakSelf.view)).borderStyle=borderStyle;
        return weakSelf;
    };
}

@end











