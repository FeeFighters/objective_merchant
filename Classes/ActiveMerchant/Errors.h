//
//  Errors.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface Errors : NSObject
{
@private
	NSMutableDictionary *realDict;
	id base;
}

- (id) init:(id)base;
- (NSString*) on:(NSString *)field;
- (void) add:(NSString *)field error:(NSString*)error;
- (void) addToBase:(NSString*)error;
- (NSArray*) fullMessages;

- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;
- (void)removeAllObjects;

@end
