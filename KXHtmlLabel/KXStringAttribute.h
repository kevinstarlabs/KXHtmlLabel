// KXStringAttribute.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KXStringAttribute : NSObject

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSNumber *underlineStyle;
@property (nonatomic, strong) UIColor *underlineColor;
@property (nonatomic, strong) NSNumber *strikethroughStyle;
@property (nonatomic, strong) UIColor *strikethroughColor;

#pragma Paragraph

@property(assign, nonatomic) CGFloat lineSpacing;
@property(assign, nonatomic) NSLineBreakMode lineBreakMode;
@property(assign, nonatomic) CGFloat paragraphSpacing;
@property(assign, nonatomic) NSTextAlignment alignment;

- (NSDictionary *)allAttributes;

@end
