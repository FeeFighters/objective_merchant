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


- (NSString *) capitalizeLastLetter
{
return [NSString stringWithFormat:@"%@%@", 
		[self substringWithRange:NSMakeRange(0, [self length]-1)],
		[[self substringWithRange:NSMakeRange([self length]-1, 1)] uppercaseString]
		];
}

- (NSString *) humanize
{
	return [self stringByReplacingOccurrencesOfRegex:@"([a-z])([A-Z])" withString:@"$1 $2"];
}

- (NSString *) lowercaseFirstLetter
{
	return [NSString stringWithFormat:@"%@%@", 
			[[self substringWithRange:NSMakeRange(0, 1)] lowercaseString],
			[self substringWithRange:NSMakeRange(1, [self length]-1)]
			];
}

- (NSString *) toCamelcase
{
	int i;
	NSArray* splits = [self componentsSeparatedByRegex:@"[_\\-\\ ]+"];
	NSMutableString* ret = [NSMutableString string];
	for (i=0; i<[splits count]; i++)
		[ret appendString:[[splits objectAtIndex:i] capitalizeFirstLetter]];
	return ret;
}

@end

@interface RKLMatchEnumerator : NSEnumerator { 
	NSString *string; 
	NSString *regex; 
	NSUInteger location; 
}
- (id)initWithString:(NSString *)initString regex:(NSString *)initRegex; 

@end
		
@implementation RKLMatchEnumerator
- (id)initWithString:(NSString *)initString regex:(NSString *)initRegex
{
	if ((self = [self init]) == NULL) { return(NULL); } 
	string = [initString copy]; regex = [initRegex copy]; 
	return(self);
}
- (id)nextObject
{
	if(location != NSNotFound) { 
		NSRange searchRange = NSMakeRange(location, [string length] - location);  
		NSRange matchedRange = [string rangeOfRegex:regex inRange:searchRange];  
		location = NSMaxRange(matchedRange) + ((matchedRange.length == 0) ? 1 : 0);  
		if(matchedRange.location != NSNotFound) { return([string substringWithRange:matchedRange]); } 
	} 
	return(NULL); 
}
- (void) dealloc 
{ 
	[string release]; 
	[regex release]; 
	[super dealloc];
} 
@end

@implementation NSString (RegexKitLiteEnumeratorAdditions)
- (NSEnumerator *)matchEnumeratorWithRegex:(NSString *)regex 
{
	return([[[RKLMatchEnumerator alloc] initWithString:self regex:regex] autorelease]);
} 
@end
