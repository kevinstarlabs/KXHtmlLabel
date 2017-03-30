//
//  KXmlCacheManager.cpp
//  KAppKit
//
//  Created by kevin on 2016/4/4.
//  Copyright © 2016年 mitira.com. All rights reserved.
//

#import "KXXmlCacheManager.h"

const static NSUInteger kKXMaxXmlCacheSize = 250;

@interface KXXmlCacheManager()

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, KXXmlObject *> *cacheValue;
@property(nonatomic, strong) NSMutableOrderedSet<NSNumber *> *cacheKeys;

@end

@implementation KXXmlCacheManager

+ (KXXmlCacheManager *)sharedManager {
    static KXXmlCacheManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.cacheValue = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.cacheKeys = [[NSMutableOrderedSet alloc] initWithCapacity:0];
        self.enabled = YES;
    }
    return self;
}

- (void)dealloc {
    
}


-(KXXmlObject *) getValueByXmlString:(NSString *) str
{
    if( self.enabled == NO ){
        return nil;
    }
    return [self getValueByKey:@([str hash])];
}

-(void) putValue:(KXXmlObject *)value forXmlString:(NSString *)str
{
    if( self.enabled == NO ){
        return;
    }
    [self putValue:value forKey:@([str hash])];
}

-(KXXmlObject *) getValueByKey:(NSNumber *) key
{
    KXXmlObject *value = self.cacheValue[key];
    if( value != nil ){
        [self.cacheKeys removeObject:key];
        [self.cacheKeys insertObject:key atIndex:0];
    }
    return value;
}

-(void) putValue:(KXXmlObject *)value forKey:(NSNumber *)key
{
    [self.cacheValue setObject:value forKey:key];
    
    if( [self.cacheKeys containsObject:key] ){
        [self.cacheKeys removeObject:key];
        [self.cacheKeys insertObject:key atIndex:0];
    }else{
        [self.cacheKeys insertObject:key atIndex:0];
    }
    [self trimCache:kKXMaxXmlCacheSize];
}

-(void) trimCache:(int) maxNumberOfKeys
{
    while( [self.cacheKeys count] > maxNumberOfKeys ){
        NSNumber *lastKey = [self.cacheKeys lastObject];
        [self.cacheKeys removeObject:lastKey];
        [self.cacheValue removeObjectForKey:lastKey];
    }
}

-(void) clear
{
    [self.cacheValue removeAllObjects];
    [self.cacheKeys removeAllObjects];
}

@end
