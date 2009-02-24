//
//  NSStringAdditions.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "NSStringAdditions.h"
#import "RegexKitLite.h"

@implementation NSString (RubyAdditions)

- (bool) is_blank
{
	return ([self length] == 0);
}

+ (bool) is_blank:(NSString *)str
{
	return (str==nil || [str isKindOfClass:[NSNull class]] || [str is_blank]);
}

- (NSString *) capitalizeFirstLetter
{
	return [NSString stringWithFormat:@"%@%@", 
				[[self substringWithRange:NSMakeRange(0, 1)] uppercaseString],
				[self substringWithRange:NSMakeRange(1, [self length]-1)]
			];
}

- (NSString *) humanize
{
	return [self stringByReplacingOccurrencesOfRegex:@"([a-z])([A-Z])" withString:@"$1 $2"];
}

@end
