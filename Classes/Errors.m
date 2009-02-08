//
//  Errors.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Errors.h"


@implementation Errors

- (id) init:(id)_base
{
	base = _base;
	return self;
}

- (NSString*) on:(NSString *)field
{
	NSMutableArray* arr = [self objectForKey:field];
	if ([arr count]>0)
		return [arr objectAtIndex:0];
	return nil;
}

- (void) add:(NSString *)field error:(NSString*)error
{
	NSMutableArray *keyArray = [self objectForKey:field];
	if (keyArray==nil) {
		keyArray = [[NSMutableArray alloc] init];
		[self setObject:keyArray forKey:field];
	}
	[keyArray addObject:error];
}

- (void) addToBase:(NSString*)error
{
	return [self add:@"base" error:error];
}

- (NSArray*) fullMessages
{
	NSMutableArray *errors = [[NSMutableArray alloc] init];
	NSString *key;
	NSEnumerator *enumerator;
	enumerator = [self keyEnumerator];
	while (key = [enumerator nextObject]) {
		NSMutableArray *curArray = [self objectForKey:key];
		NSString *errormsg;
		if ([key isEqualToString:@"base"]) {
			 errormsg = [NSString stringWithString:[curArray objectAtIndex:0]];
		} else {
			 errormsg = [NSString stringWithFormat:@"%s %s", key, [curArray objectAtIndex:0]];			
		}
		[errors addObject:errormsg];
	}
	return errors;
}

@end
