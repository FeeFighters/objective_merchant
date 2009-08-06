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
	return dayvals.length-1;
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
	return ([today compare:_exp] != NSOrderedAscending);
}

- (NSDate *) expiration
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	//[dateFormatter setDateFormat:@"%m/%d/%Y"];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d/%02d/%04d", [month intValue], [self monthDays], [year intValue]]];
	return date;
}


@end
