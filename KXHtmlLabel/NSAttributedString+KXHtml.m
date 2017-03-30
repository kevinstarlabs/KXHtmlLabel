// NSAttributedString+KXHtml.m
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

#import "NSAttributedString+KXHtml.h"

#import "KXStringAttribute.h"

#import "KXXmlParser.h"
#import "UIColor+KXHex.h"

#import "KXFontAwesome.h"

#import "KXXmlCacheManager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define KX_DICTIONARY_CONTAINS(x,y) ( [x objectForKey:y] != nil && x[y].length > 0 )

@implementation NSAttributedString (KXHtml)

+(float) convertUnit:(NSString *) s
{
    return [s intValue];
}

+(NSAttributedString *) attributedStringFromHtml:(NSString *)htmlString
                                            font:(UIFont *)defaultFont
                                           color:(UIColor *)defaultColor
{
    if( htmlString == nil ){
        return nil;
    }
    
    NSMutableArray<KXXmlObject *> *stack = [[NSMutableArray alloc] initWithCapacity:0];
    
    KXXmlObject *cachedXmlObject = [[KXXmlCacheManager sharedManager] getValueByXmlString:htmlString];
    
    KXXmlObject *xmlObject = nil;
    
    if( cachedXmlObject != nil ){
        xmlObject = cachedXmlObject;
    }else{
        xmlObject = [KXXmlParser parseFromString:htmlString];
        if( xmlObject != nil ){
            [[KXXmlCacheManager sharedManager] putValue:xmlObject forXmlString:htmlString];
        }
    }
    
    if( xmlObject != nil ){
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self buildAttributedStringList:list
                                fromXml:xmlObject
                              withStack:stack
                                   font:defaultFont
                                  color:defaultColor
                numberOfParagraphsAhead:0];
        
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] init];
        for( NSAttributedString *s in list ){
            [totalStr appendAttributedString:s];
        }
        
        return totalStr;
    }else{
        NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:htmlString];
        return s;
    }
}


+(BOOL) isValidFontWeight:(NSString *)weight
{
    /*
     UIFontWeightUltraLight
     UIFontWeightThin
     UIFontWeightLight
     UIFontWeightRegular
     UIFontWeightMedium
     UIFontWeightSemibold
     UIFontWeightBold
     UIFontWeightHeavy
     UIFontWeightBlack
     */
    NSString *w = [weight lowercaseString];
    static NSString *predefinedWeightNames[] = {@"ultralight",@"thin",@"light",@"regular",@"medium",@"semibold",@"bold",@"heavy",@"black"};
    const int count = sizeof (predefinedWeightNames) / sizeof (*predefinedWeightNames);
    for( int i=0;i<count;++i ){
        if( [w isEqualToString:predefinedWeightNames[i]] ){
            return YES;
        }
    }
    return NO;
}

+(CGFloat) getFontWight:(NSString *)weight
{
    NSString *w = [weight lowercaseString];
    static NSString *predefinedWeightNames[] = {@"ultralight",@"thin",@"light",@"regular",@"medium",@"semibold",@"bold",@"heavy",@"black"};
    CGFloat predefinedWeights[] = {
        UIFontWeightUltraLight,
        UIFontWeightThin,
        UIFontWeightLight,
        UIFontWeightRegular,
        UIFontWeightMedium,
        UIFontWeightSemibold,
        UIFontWeightBold,
        UIFontWeightHeavy,
        UIFontWeightBlack
    };
    const int count = sizeof (predefinedWeightNames) / sizeof (*predefinedWeightNames);
    for( int i=0;i<count;++i ){
        if( [w isEqualToString:predefinedWeightNames[i]] ){
            return predefinedWeights[i];
        }
    }
    return 0;
}

+(KXStringAttribute *) createInheritedAttributesFromStack:(NSMutableArray<KXXmlObject *> *)stack
                                                   font:(UIFont *)defaultFont
                                                  color:(UIColor *)defaultColor
{
    NSString *typeface = nil;
    
    BOOL bold = NO;
    BOOL italic = NO;
    BOOL underline = NO;
    BOOL strike = NO;
    float fontSize = 0;
    NSString *color = nil;
    NSString *bgColor = nil;
    NSString *paraAlign = nil;
    NSString *paraLineBreakMode = nil;
    NSString *paraLineSpacing = nil;
    NSString *fontWeight = nil;
    
    const float defaultFontSize = defaultFont.pointSize;
    
    for( int i = 0 ; i < [stack count] ; ++i ){
        
        KXXmlObject *node = stack[i];

        if( [node.name isEqualToString:@"font"] ){
            
            bold = NO;
            italic = NO;
            
            if( KX_DICTIONARY_CONTAINS(node.attributes,@"face") ){
                typeface = node.attributes[@"face"];
            }
            
            if( KX_DICTIONARY_CONTAINS(node.attributes,@"weight") ){
                fontWeight = node.attributes[@"weight"];
            }
            
            if( KX_DICTIONARY_CONTAINS(node.attributes,@"size") ){
                
                NSString *sizeStr = node.attributes[@"size"];

                if( [sizeStr hasPrefix:@"+"] ){
                    if( sizeStr.length >= 2 ){
                        fontSize = defaultFontSize + [self convertUnit:[sizeStr substringFromIndex:1]];
                    }
                }else if( [sizeStr hasPrefix:@"-"] ){
                    if( sizeStr.length >= 2 ){
                        fontSize = defaultFontSize - [self convertUnit:[sizeStr substringFromIndex:1]];
                    }
                }else if( [sizeStr hasPrefix:@"*"] ){
                    if( sizeStr.length >= 2 ){
                        fontSize = defaultFontSize * [self convertUnit:[sizeStr substringFromIndex:1]];
                    }
                }else{
                    fontSize = [self convertUnit:sizeStr];
                }
            }
            if( KX_DICTIONARY_CONTAINS(node.attributes, @"color") ){
                
                NSString *colorStr = node.attributes[@"color"];
                color = colorStr;
                
            }
            if( KX_DICTIONARY_CONTAINS(node.attributes, @"bgcolor") ){
                NSString *colorStr = node.attributes[@"bgcolor"];
                bgColor = colorStr;
            }
            
        }else if( [node.name isEqualToString:@"b"] ){
            bold = YES;
        }else if( [node.name isEqualToString:@"i"] ){
            if( [node containsFontAwesomeClass] == NO ){
                italic = YES;
            }
        }else if( [node.name isEqualToString:@"u"] ){
            underline = YES;
        }else if( [node.name isEqualToString:@"s"] ){
            strike = YES;
        }else if( [node.name isEqualToString:@"p"] ){
            
            if( KX_DICTIONARY_CONTAINS(node.attributes, @"align") ){
                paraAlign = [node.attributes[@"align"] lowercaseString];
            }
            if( KX_DICTIONARY_CONTAINS(node.attributes, @"linebreakmode") ){
                paraLineBreakMode = [node.attributes[@"linebreakmode"] lowercaseString];
            }
            if( KX_DICTIONARY_CONTAINS(node.attributes, @"linespacing") ){
                paraLineSpacing = [node.attributes[@"linespacing"] lowercaseString];
            }
        }else if( [node.name isEqualToString:@"root"] ){
            fontSize = defaultFontSize;
        }
    }
    
    KXStringAttribute *attr = [[KXStringAttribute alloc] init];

    attr.font = [UIFont boldSystemFontOfSize:22.f];
    
    attr.foregroundColor = [UIColor blackColor];
    
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2") ){
        
        if( fontWeight != nil && fontWeight.length > 0 && [self isValidFontWeight:fontWeight] ){
            if( bold ){
                attr.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
            }else if( italic ){
                attr.font = [UIFont italicSystemFontOfSize:fontSize];
            }else{
                attr.font = [UIFont systemFontOfSize:fontSize weight:[self getFontWight:fontWeight]];
            }
        }else{
            if( bold ){
                attr.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
            }else if( italic ){
                attr.font = [UIFont italicSystemFontOfSize:fontSize];
            }else{
                attr.font = [UIFont systemFontOfSize:fontSize];
            }
        }
    }else{
        if( bold ){
           attr.font = [UIFont boldSystemFontOfSize:fontSize];
        }else if( italic ){
           attr.font = [UIFont italicSystemFontOfSize:fontSize];
        }else{
            if( typeface != nil && typeface.length > 0 ){
                attr.font = [UIFont fontWithName:typeface size:fontSize];
            }else if( (typeface == nil || typeface.length == 0) && fontSize > 0 ){
                attr.font = [defaultFont fontWithSize:fontSize];
            }
        }
    }
    
    if( color != nil && color.length > 0 ){
        attr.foregroundColor = [UIColor colorWithCSS:color];
    }else{
        attr.foregroundColor = defaultColor;
    }
    
    if( bgColor != nil && bgColor.length > 0 ){
        attr.backgroundColor = [UIColor colorWithCSS:bgColor];
    }
    
    if( underline ){
        attr.underlineStyle = @(NSUnderlineStyleSingle);
    }
    
    if( strike ){
        attr.strikethroughStyle = @(NSUnderlinePatternSolid | NSUnderlineStyleSingle);
    }
    
    if( paraAlign != nil && paraAlign.length > 0 ){
        if( [paraAlign isEqualToString:@"left"] ){
            attr.alignment = NSTextAlignmentLeft;
        }else if( [paraAlign isEqualToString:@"center"] ){
            attr.alignment = NSTextAlignmentCenter;
        }else if( [paraAlign isEqualToString:@"right"] ){
            attr.alignment = NSTextAlignmentRight;
        }else if( [paraAlign isEqualToString:@"justify"] ){
            attr.alignment = NSTextAlignmentJustified;
        }
    }
    
    if( paraLineBreakMode != nil && paraLineBreakMode.length > 0 ){
        if( [paraLineBreakMode isEqualToString:@"wordwrap"] ){
            attr.lineBreakMode = NSLineBreakByWordWrapping;
        }else if( [paraLineBreakMode isEqualToString:@"charwrap"] ){
            attr.lineBreakMode = NSLineBreakByCharWrapping;
        }else if( [paraLineBreakMode isEqualToString:@"clipping"] ){
            attr.lineBreakMode = NSLineBreakByClipping;
        }else if( [paraLineBreakMode isEqualToString:@"truncatehead"] ){
            attr.lineBreakMode = NSLineBreakByTruncatingHead;
        }else if( [paraLineBreakMode isEqualToString:@"truncatetail"] ){
            attr.lineBreakMode = NSLineBreakByTruncatingTail;
        }else if( [paraLineBreakMode isEqualToString:@"truncatemiddle"] ){
            attr.lineBreakMode = NSLineBreakByTruncatingMiddle;
        }
    }
    
    if( paraLineSpacing != nil && paraLineSpacing.length > 0 ){
        attr.lineSpacing = [self convertUnit:paraLineSpacing];
    }
    return attr;
}

+(void) buildAttributedStringList:(NSMutableArray *)list
                          fromXml:(KXXmlObject *) parent
                        withStack:(NSMutableArray<KXXmlObject *> *)stack
                             font:(UIFont *)defaultFont
                            color:(UIColor *)defaultColor
           numberOfParagraphsAhead:(NSInteger)numberOfParagraphsAhead
{
    
    if( parent.name.length > 0 ){
        
        
        if( [parent.name isEqualToString:@"i"] && [parent containsFontAwesomeClass] ){
            
            NSString *iconId = nil;
            NSString *iconColor = nil;
            NSString *iconBgColor = nil;
            
            if( KX_DICTIONARY_CONTAINS(parent.attributes, @"class") ){
                iconId = [parent getFontAwesomeClassName];
            }
            
            if( iconId != nil && iconId.length > 0 ){
                
                if( KX_DICTIONARY_CONTAINS(parent.attributes, @"color") ){
                    iconColor = parent.attributes[@"color"];
                }
                if( KX_DICTIONARY_CONTAINS(parent.attributes, @"bgcolor") ){
                    iconBgColor = parent.attributes[@"bgcolor"];
                }
                
                UIFont *iconFont = [KXFontAwesome fontOfSize:defaultFont.pointSize];
                
                if( iconFont != nil ){
                    KXStringAttribute *attr = [self createInheritedAttributesFromStack:stack
                                                                                  font:defaultFont
                                                                                 color:defaultColor];
                    if( attr.font != nil ){
                        attr.font = [iconFont fontWithSize:attr.font.pointSize];
                    }else{
                        attr.font = iconFont;
                    }
                    
                    if( iconColor.length > 0 ){
                        attr.foregroundColor = [UIColor colorWithCSS:iconColor];
                    }
                    
                    if( iconBgColor.length > 0 ){
                        attr.backgroundColor = [UIColor colorWithCSS:iconBgColor];
                    }
                    
                    NSString *codeChar = [KXFontAwesome iconDictionary][iconId];
                    
                    if( codeChar != nil ){
                        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:codeChar
                                                                                     attributes:attr.allAttributes];
                        [list addObject:attStr];
                    }
                }
                
            }
        }
        
        [stack addObject:parent];
        
        if( [parent.name isEqualToString:@"br"] ){
            KXStringAttribute *attr = [self createInheritedAttributesFromStack:stack
                                                                          font:defaultFont
                                                                         color:defaultColor];
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"\n"
                                                                         attributes:attr.allAttributes];
            [list addObject:attStr];
        }
        
        NSInteger newNumberOfParagraphsAhead = numberOfParagraphsAhead;
        
        for( KXXmlObject *child in parent.children ){
            
            if( [child.name isEqualToString:@"p"] ){
                if( newNumberOfParagraphsAhead > 0 ){
                    // Automatically add a new line before a paragraph.
                    KXStringAttribute *attr = [self createInheritedAttributesFromStack:stack
                                                                                  font:defaultFont
                                                                                 color:defaultColor];
                    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"\n"
                                                                                 attributes:attr.allAttributes];
                    [list addObject:attStr];
                }
                newNumberOfParagraphsAhead++;
            }
            
            [self buildAttributedStringList:list
                                    fromXml:child
                                  withStack:stack
                                       font:defaultFont
                                      color:defaultColor
                    numberOfParagraphsAhead:newNumberOfParagraphsAhead];
        }
        
        [stack removeLastObject];
        
    }else if( parent.content != nil && parent.content.length > 0 ){
        
        KXStringAttribute *attr = [self createInheritedAttributesFromStack:stack
                                                                    font:defaultFont
                                                                   color:defaultColor];
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:parent.content
                                                                     attributes:attr.allAttributes];
        
        [list addObject:attStr];
    }
}


@end
