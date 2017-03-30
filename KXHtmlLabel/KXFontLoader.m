//
//  KXFontLoader.m
//  KXHtmlLabelDemo
//
//  Created by kevin on 2017/3/30.
//  Copyright © 2017年 kxzon.com. All rights reserved.
//

#import "KXFontLoader.h"

#import <CoreText/CoreText.h>

@implementation KXFontLoader

+(void) loadFontFromUrl:(NSURL *) fontFileUrl
{
    NSAssert( fontFileUrl != nil && [[NSFileManager defaultManager] fileExistsAtPath: [fontFileUrl path]], @"Unable to load FontAwesome.otf. Please make sure the font has been added to the project.");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL( (__bridge CFURLRef) fontFileUrl );
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error = NULL;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
    if ( error != NULL ) {
        CFRelease(error);
    }
}

@end
