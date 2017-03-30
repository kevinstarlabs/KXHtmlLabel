// KXStringAttribute.m
// Copyright (c) 2016-2017 kxzen ( https://github.com/kxzen/KXHtmlLabel )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KXStringAttribute.h"

@interface KXStringAttribute ()

@property (strong, nonatomic) NSMutableDictionary *attributes;
@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;

@end

@implementation KXStringAttribute

- (id)init {
    self = [super init];
    if (self) {
        self.attributes = [[NSMutableDictionary alloc] init];
        self.paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.attributes[NSFontAttributeName] = [font copy];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    self.attributes[NSForegroundColorAttributeName] = [foregroundColor copy];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.attributes[NSBackgroundColorAttributeName] = [backgroundColor copy];
}

- (void)setStrikethroughStyle:(NSNumber *)strikethroughStyle {
    _strikethroughStyle = strikethroughStyle;
    self.attributes[NSStrikethroughStyleAttributeName] = [strikethroughStyle copy];
}

- (void)setUnderlineStyle:(NSNumber *)underlineStyle {
    _underlineStyle = underlineStyle;
    self.attributes[NSUnderlineStyleAttributeName] = [underlineStyle copy];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    self.paragraphStyle.lineSpacing = lineSpacing;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.paragraphStyle.lineBreakMode = lineBreakMode;
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    _paragraphSpacing = paragraphSpacing;
    self.paragraphStyle.paragraphSpacing = paragraphSpacing;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    _alignment = alignment;
    self.paragraphStyle.alignment = alignment;
}

- (NSDictionary *)allAttributes {
    self.attributes[NSParagraphStyleAttributeName] = [self.paragraphStyle copy];
    return self.attributes;
}

@end
