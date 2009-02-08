//
//  NSStringAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "NSStringAdditions.h"


@implementation NSString (RubyAdditions)

- (bool) is_blank
{
	return ([self length] == 0);
}

+ (bool) is_blank:(NSString *)str
{
	return (str==nil || [str is_blank]);
}


@end
