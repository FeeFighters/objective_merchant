//
//  ExpiryDate.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "ExpiryDate.h"


@implementation BillingExpiryDate

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
- (id) init:(NSInteger)_month year:(NSInteger)_year
{
	month = _month;
	year = _year;
	return self;
}

- (bool) is_expired
{
	NSDate *today = [NSDate date];
	return [today isGreaterThan:[self expiration]];
}

- (NSDate *) expiration
{
	return [NSDate dateWithString:[NSString stringWithFormat:@"%04d-%02d-%02d 23:59:59 +0000", year, month, [self monthDays]]];
}


@end
