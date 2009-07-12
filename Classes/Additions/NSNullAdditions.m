//
//  NSDataAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "NSNullAdditions.h"

@implementation NSNull (TransFSAdditions)

+ (bool) isNull:(id)obj
{
	bool r = (obj==nil || [obj isEqual:[NSNull null]]);
	return r;
}

@end
