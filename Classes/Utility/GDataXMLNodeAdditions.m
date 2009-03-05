//
//  GDataXMLNodeAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GDataXMLNode.h"
#import "GDataXMLNodeAdditions.h"

@implementation GDataXMLNode (ObjectiveMerchantAdditions)

- (NSUInteger)elementChildCount
{
	return [[self elementChildren] count];
}

- (NSArray *)elementChildren
{
	NSMutableArray* children = [NSMutableArray array];
	NSEnumerator* enumerator = [[self children] objectEnumerator];
	GDataXMLNode* node;
	while (node = [enumerator nextObject]) 
	{
		if (![[node name] isEqualToString:@"text"])
			[children addObject:node];
	}
	return children;
}

@end
