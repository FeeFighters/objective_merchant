//
//  ExpiryDate.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExpiryDate.h"


@implementation ExpiryDate

@synthesize month, year;

//
// Private
//
- (int) monthDays
{
	NSCalendar *curCalendar = [NSCalendar currentCalendar];
	NSRange dayvals = [curCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
	return dayvals.location+dayvals.length-1;
}

//
// Public
//
- (id) init:(NSString *)_month year:(NSString *)_year
{
	month = [NSString stringWithString:_month];
	year = [NSString stringWithString:_year];
	return self;
}

- (bool) is_expired
{
	NSDate *today = [NSDate date];
	return [today isGreaterThan:[self expiration]];
}

- (NSDate *) expiration
{
	return [NSDate dateWithString:[NSString stringWithFormat:@"%s-%s-%s 23:59:59 +0000", year, month, [self monthDays]]];
}


@end
