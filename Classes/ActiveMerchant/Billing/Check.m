//
//  Check.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Check.h"
#import "NSStringAdditions.h"

@implementation BillingCheck

@synthesize firstName, lastName, routingNumber, accountNumber, accountHolderType, accountType, number;
@synthesize institutionNumber, transitNumber;

- (NSString *) name
{
	if ([NSString is_blank:_name])
	{
		_name = [NSString stringWithFormat:@"%s %s", firstName, lastName];
	}
	return _name;
}

- (void) setName:(NSString *)name 
{
	if ([NSString is_blank:_name])
		return;
	
	_name = name;
	NSMutableArray *chunks = [NSMutableArray arrayWithArray:[name componentsSeparatedByString: @" "]];
	lastName = [NSString stringWithString:[chunks objectAtIndex:0]];
	[chunks removeObjectAtIndex:0];
	firstName = [NSString stringWithString:[chunks componentsJoinedByString: @" "]];
	[chunks release];
}

- (void) validate
{
	if ([NSString is_blank:_name])
		[_errors add:@"name" error:@"cannot be empty"];
	if ([NSString is_blank:routingNumber])
		[_errors add:@"routingNumber" error:@"cannot be empty"];
	if ([NSString is_blank:accountNumber])
		[_errors add:@"accountNumber" error:@"cannot be empty"];

	if (![self is_validRoutingNumber])
		[_errors add:@"routingNumber" error:@"is invalid"];

	if ( ![NSString is_blank:accountHolderType] && 
		 !([accountHolderType isEqualToString:@"business"] || [accountHolderType isEqualToString:@"personal"]) )
		[_errors add:@"accountHolderType" error:@"must be personal or business"];

	if ( ![NSString is_blank:accountType] && 
		!([accountType isEqualToString:@"checking"] || [accountType isEqualToString:@"savings"]) )
		[_errors add:@"accountType" error:@"must be checking or savings"];
}

- (NSString *) type
{
	return @"check";
}

//# Routing numbers may be validated by calculating a checksum and dividing it by 10. The
//# formula is:
//#   (3(d1 + d4 + d7) + 7(d2 + d5 + d8) + 1(d3 + d6 + d9))mod 10 = 0
//# See http:// en.wikipedia.org/wiki/Routing_transit_number#Internal_checksums
- (bool) is_validRoutingNumber
{
	int d[ [routingNumber length] ];
	int dlen = 0;
	for (int i=0; i<[routingNumber length]; i++) 
	{
		int val = [[routingNumber substringWithRange:NSMakeRange(i,1)] intValue];
		if (val >= 0 && val <= 9) {
			d[dlen++] = val;
		}
	}
	if (dlen==9) 
	{
		int checksum = ((3 * (d[0] + d[3] + d[6])) + 
						(7 * (d[1] + d[4] + d[7])) +
						(d[2] + d[5] + d[8])) % 10;
		if (checksum==0) return true;
		return false;
	} 
	return false;
}

#include "Validatable_Implementation.h"

@end
