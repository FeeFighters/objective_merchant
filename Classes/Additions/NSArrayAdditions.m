//
//  NSArrayAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "NSArrayAdditions.h"


@implementation NSArray (TransFSAdditions)

- (bool) containsStringEqualTo:(NSString *)str
{
	id obj;
	NSEnumerator *enumerator = [self objectEnumerator];
	while (obj = [enumerator nextObject]) {
		if ([obj isKindOfClass:[NSString class]]) {
			if ([(NSString*)obj isEqualToString:str])
				return true;
		}
	}
	return false;
}

@end
