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
- (id) init:(NSNumber*)_month year:(NSNumber*)_year
{
	month = _month;
	year = _year;
	return self;
}

- (bool) is_expired
{
	NSDate *today = [NSDate date];
	NSDate *_exp = [self expiration];	
	return [today isGreaterThan:_exp];
}

- (NSDate *) expiration
{
	return [NSDate dateWithString:[NSString stringWithFormat:@"%04d-%02d-%02d 23:59:59 +0000", [year intValue], [month intValue], [self monthDays]]];
}


@end
