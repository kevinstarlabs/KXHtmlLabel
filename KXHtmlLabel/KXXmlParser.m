// KXXmlParser.m
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

#import "KXXmlParser.h"

#define CLEAR_NSMUTABLESTRING(x) if( x != nil && x.length > 0 )[x deleteCharactersInRange:NSMakeRange(0, x.length)];

@interface KXXmlParser()


@end

static NSString *closingTags[] = {@"p",@"font",@"u",@"i",@"b",@"s",@"t"};

@implementation KXXmlParser

+(BOOL) belongsToClosingTag:(NSString *)tag
{
    const int numTags = sizeof (closingTags) / sizeof (*closingTags);
    for( int i = 0 ; i < numTags ; ++i ){
        if( [tag isEqualToString: closingTags[i]] ){
            return YES;
        }
    }
    return NO;
}

+(NSInteger) findNextOccurrenceInSource:(NSString *)source
                               startPos:(NSInteger) startPos
                                 target:(NSString *) target
                        caseInsensitive:(BOOL) caseInsensitive
{
    BOOL enterSingleQuote = NO;
    BOOL enterDoubleQuote = NO;
    const NSInteger maxLen = MAX( (NSInteger)(source.length - target.length + 1), 0);
    for( NSInteger i = startPos ; i < maxLen ; ++i ){
        unichar c = [source characterAtIndex:i];

        if( c == '\"' ){
            if( enterDoubleQuote ){
                enterDoubleQuote = NO;
            }else{
                if( enterSingleQuote == NO ){
                    enterDoubleQuote = YES;
                }
            }
        }else if( c == '\'' ){
            if( enterSingleQuote ){
                enterSingleQuote = NO;
            }else{
                if( enterDoubleQuote == NO ){
                    enterSingleQuote = YES;
                }
            }
        }else if( i + 1 < maxLen && c == '\\' ){
            unichar nextc = [source characterAtIndex:i+1];
            if( nextc == '\"' || nextc == '\'' || nextc == '\\' ){
                i++;
            }
        }else{
            if( !enterSingleQuote && !enterDoubleQuote ){
                if( [source compare:target
                            options:(caseInsensitive?NSCaseInsensitiveSearch:0)
                              range:NSMakeRange(i, target.length)] == NSOrderedSame ){
                    return i;
                }
            }
        }
    }
        
    return -1;
}

+(NSInteger) findNextOccurrenceOfClosingTag:(NSString *) tagName
                                     source:(NSString *) source
                                   startPos:(NSInteger) startPos
{
    BOOL enterSingleQuote = NO;
    BOOL enterDoubleQuote = NO;
    NSString *strTagBegin1 = [NSString stringWithFormat:@"<%@>", tagName];
    NSString *strTagBegin2 = [NSString stringWithFormat:@"<%@", tagName];
    NSString *strTagEnd = [NSString stringWithFormat:@"</%@>", tagName];
    const NSInteger maxLen = MAX( (NSInteger)(source.length - strTagEnd.length + 1), 0);
    int numberOfTagsBegins = 0;
    for( NSInteger i = startPos ; i < maxLen ; ++i ){
        
        unichar c = [source characterAtIndex:i];
        if( c == '\"' ){
            if( enterDoubleQuote ){
                enterDoubleQuote = NO;
            }else{
                if( enterSingleQuote == NO ){
                    enterDoubleQuote = YES;
                }
            }
        }else if( c == '\'' ){
            if( enterSingleQuote ){
                enterSingleQuote = NO;
            }else{
                if( enterDoubleQuote == NO ){
                    enterSingleQuote = YES;
                }
            }
        }else if( i + 1 < maxLen && c == '\\' ){
            unichar nextc = [source characterAtIndex:i+1];
            if( nextc == '\"' || nextc == '\'' || nextc == '\\' ){
                i++;
            }
        }else{
            if( !enterSingleQuote && !enterDoubleQuote ){
                if( [source compare:strTagBegin1 options:NSCaseInsensitiveSearch
                              range:NSMakeRange(i, strTagBegin1.length)] == NSOrderedSame ){
                    numberOfTagsBegins++;
                }else if( [source compare:strTagBegin2 options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(i, strTagBegin2.length)] == NSOrderedSame ){
                    if( i+strTagBegin2.length < source.length ){
                        if(  [source characterAtIndex:i+strTagBegin2.length] == ' ' ||
                           [source characterAtIndex:i+strTagBegin2.length] == '\t' ||
                           [source characterAtIndex:i+strTagBegin2.length] == '\n' ){
                            numberOfTagsBegins++;
                        }
                    }
                }else if( [source compare:strTagEnd options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(i, strTagEnd.length)] == NSOrderedSame ){
                    
                    if( numberOfTagsBegins == 0 ){
                        return i;
                    }
                    
                    if( numberOfTagsBegins > 0 ){
                        numberOfTagsBegins--;
                    }
                }
            }
        }
    }
    return -1;
}

+(KXXmlObject *_Nullable) parseFromString:(NSString * _Nonnull)s
{
    KXXmlObject *root = [[KXXmlObject alloc] init];
    root.name = @"root";
    root.depth = 0;
    [self parseFromString:s parent:root];
    return root;
}

+(void) parseFromString:(NSString * _Nonnull)s parent:(KXXmlObject * _Nonnull)parent
{
    NSInteger p = 0;
    
    NSMutableString *content = [[NSMutableString alloc] initWithCapacity:0];
    
    while( p < s.length ){
        
        if( [s characterAtIndex:p] == '<' ){
            
            if( content.length > 0 ){
                KXXmlObject *newChild = [[KXXmlObject alloc] init];
                newChild.depth = parent.depth + 1;
                newChild.content = [content copy];
                [parent.children addObject:newChild];
                [self parseFromString:@"" parent:newChild];
                CLEAR_NSMUTABLESTRING(content);
            }
            
            NSString *tagString = nil;
            ++p;
            
            NSInteger nextRightAngleBracketPos = [self findNextOccurrenceInSource:s startPos:p target:@">" caseInsensitive:NO];
            
            if( nextRightAngleBracketPos >= 0 ){
                tagString = [s substringWithRange:NSMakeRange(p, nextRightAngleBracketPos-p)];
                p = nextRightAngleBracketPos + 1;
            }else{
                NSLog(@"Unable to find right angle bracket for string [%@...]",
                      [s substringToIndex:MAX(s.length, 24)] );
                break;
            }
            
            if( tagString != nil && tagString.length > 0 ){
                
                NSMutableString *token = [[NSMutableString alloc] initWithCapacity:0];
                NSMutableArray<NSString *> *tokenList = [[NSMutableArray alloc] init];
                
                NSInteger tagStringNowPos = 0;
                
                while( tagStringNowPos < tagString.length ){

                    const unichar c = [tagString characterAtIndex:tagStringNowPos];

                    if( c == ' ' || c == '\t' || c == '\n' ) {
                        if ( token.length > 0 ) {
                            [tokenList addObject:[token copy]];
                            CLEAR_NSMUTABLESTRING(token);
                        }
                        ++tagStringNowPos;
                    }else if( c == '=' ) {
                        if ( token.length > 0 ) {
                            [tokenList addObject:[token copy]];
                            CLEAR_NSMUTABLESTRING(token);
                        }
                        [tokenList addObject:@"="];
                        ++tagStringNowPos;
                    }else if( c == '\'' ){
                        ++tagStringNowPos;
                        if ( token.length > 0 ) {
                            [tokenList addObject:[token copy]];
                            CLEAR_NSMUTABLESTRING(token);
                        }
                        NSMutableString *pureString = [[NSMutableString alloc] initWithCapacity:0];
                        while( tagStringNowPos < tagString.length ){
                            
                            if( tagStringNowPos + 1 < tagString.length ){
                                
                                unichar peek1 = [tagString characterAtIndex:tagStringNowPos];
                                unichar peek2 = [tagString characterAtIndex:tagStringNowPos+1];
                                
                                if( peek1 == '\\' && peek2 == '\"' ){
                                    [pureString appendString:@"\""];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\t' ){
                                    [pureString appendString:@"\t"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\n' ){
                                    [pureString appendString:@"\n"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if(  peek1 == '\\' && peek2 == '\\' ){
                                    [pureString appendString:@"\\"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\'' ) {
                                    [pureString appendString:@"\'"];
                                    tagStringNowPos+=2;
                                    continue;
                                }
                            }
                            
                            if( [tagString characterAtIndex:tagStringNowPos] == '\'' ){
                                tagStringNowPos++;
                                break;
                            }else{
                                [pureString appendFormat:@"%c", [tagString characterAtIndex:tagStringNowPos]];
                                tagStringNowPos++;
                            }
                        }
                        if( pureString.length > 0 ){
                            [tokenList addObject:[pureString copy]];
                        }else{
                            [tokenList addObject:@""];
                        }
                    }else if( c == '\"' ){
                        ++tagStringNowPos;
                        if ( token.length > 0 ) {
                            [tokenList addObject:[token copy]];
                            CLEAR_NSMUTABLESTRING(token);
                        }
                        NSMutableString *pureString = [[NSMutableString alloc] initWithCapacity:0];
                        while( tagStringNowPos < tagString.length ){
                            
                            if( tagStringNowPos + 1 < tagString.length ){
                                
                                unichar peek1 = [tagString characterAtIndex:tagStringNowPos];
                                unichar peek2 = [tagString characterAtIndex:tagStringNowPos+1];
                                
                                if( peek1 == '\\' && peek2 == '\"' ){
                                    [pureString appendString:@"\""];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\t' ){
                                    [pureString appendString:@"\t"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\n' ){
                                    [pureString appendString:@"\n"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if(  peek1 == '\\' && peek2 == '\\' ){
                                    [pureString appendString:@"\\"];
                                    tagStringNowPos+=2;
                                    continue;
                                }else if( peek1 == '\\' && peek2 == '\'' ) {
                                    [pureString appendString:@"\'"];
                                    tagStringNowPos+=2;
                                    continue;
                                }
                            }
                            
                            if( [tagString characterAtIndex:tagStringNowPos] == '\"' ){
                                tagStringNowPos++;
                                break;
                            }else{
                                [pureString appendFormat:@"%c", [tagString characterAtIndex:tagStringNowPos]];
                                tagStringNowPos++;
                            }
                        }
                        if( pureString.length > 0 ){
                            [tokenList addObject:[pureString copy]];
                        }else{
                            [tokenList addObject:@""];
                        }
                    }else{
                        [token appendFormat:@"%c", c];
                        ++tagStringNowPos;
                    }
                    
                }
                
                if ( token.length > 0 ) {
                    [tokenList addObject:[token copy]];
                    CLEAR_NSMUTABLESTRING(token);
                }
                
                if( [tokenList count] > 0 ) {
                    KXXmlObject *newChild = [[KXXmlObject alloc] init];
                    newChild.depth = parent.depth + 1;
                    newChild.name = [[tokenList firstObject] lowercaseString];
                    int tokenIndex = 1;
                    while ( tokenIndex < [tokenList count] ) {
                        if( tokenList[tokenIndex].length > 0 &&
                            [tokenList[tokenIndex] characterAtIndex:0] != '=' ){
                            if( tokenIndex + 2 < [tokenList count] && [tokenList[tokenIndex+1] isEqualToString:@"="] ){
                                NSString *key = [tokenList[tokenIndex] lowercaseString];
                                NSString *value = tokenList[tokenIndex+2];
                                if( key.length > 0 ) {
                                    newChild.attributes[key] = value;
                                }
                                tokenIndex +=3;
                            }else{
                                tokenIndex++;
                            }
                        }else {
                            ++tokenIndex;
                        }
                    }
                    
                    if( [self belongsToClosingTag:newChild.name] ) {
                        NSString *endTag = [NSString stringWithFormat:@"</%@>", newChild.name];
                        NSInteger endTagPos = [self findNextOccurrenceOfClosingTag:newChild.name source:s startPos:p];
                        if (endTagPos >= 0) {
                            NSString *childContent = [s substringWithRange:NSMakeRange(p, endTagPos-p)];
                            [self parseFromString:childContent parent:newChild];
                            p = endTagPos + (NSInteger) endTag.length;
                        } else {
                            NSLog(@"Unable to find tag \"%@\"", endTag);
                            break;
                        }
                    }
                    [parent.children addObject: newChild];
                }
            }else{
                // Invalid tag, treat it as content, ignored.
                break;
            }
        }else{
            [content appendFormat:@"%c", [s characterAtIndex:p]];
            ++p;
        }
    }
    
    if ( content.length > 0 ) {
        KXXmlObject *newChild = [[KXXmlObject alloc] init];
        newChild.depth = parent.depth + 1;
        newChild.content = [content copy];
        [parent.children addObject:newChild];
        [self parseFromString:@"" parent:newChild];
        CLEAR_NSMUTABLESTRING(content);
    }
}

@end
