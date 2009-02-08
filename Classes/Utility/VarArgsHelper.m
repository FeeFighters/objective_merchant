//
//  NSArrayAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

NSArray* _utility_VarArgsToArray(va_list ap)
{
	id obj;
	NSMutableArray* array = [NSMutableArray array];
	
	while ((obj = va_arg(ap, id))) {
		[array addObject:obj];
	}
	return array;
}
