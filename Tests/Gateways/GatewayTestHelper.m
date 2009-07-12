//
//  GatewayTestHelper.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/14/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "GatewayTestHelper.h"
#import "objCFixes.h"

@implementation GatewayTestHelper

+ (BillingCreditCard *) buildCreditCard:(NSString*)number options:(NSDictionary *)options
{
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:today];
	int todayYear = [dateComponents year];

	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									number, @"number",
									MakeInt(9), @"month",
									MakeInt(todayYear + 1), @"year",
									@"Joshua", @"firstName",
									@"Krall", @"lastName",
									@"123", @"verificationValue",
									@"visa", @"type",
								  nil];

	if (options!=nil)
		[attrs addEntriesFromDictionary:options];

	return [[BillingCreditCard alloc] init:attrs];
}

@end
