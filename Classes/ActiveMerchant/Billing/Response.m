//
//  Response.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Response.h"
#import "AvsResult.h"
#import "CvvResult.h"

@implementation BillingResponse

@synthesize params, message, test, authorization, avsResult, cvvResult;

- (id) init:(bool)_success message:(NSString *)_message params:(NSDictionary*)_params options:(NSDictionary*)_options
{
	success = _success;
	message = [_message retain];
	params = [_params retain];
	test = ([_options objectForKey:@"test"] || false);
	authorization = [_options objectForKey:@"authorization"];
	fraudReview = [_options objectForKey:@"fraudReview"];	
	avsResult = [[[BillingAvsResult alloc] init:[_options objectForKey:@"avsResult"]] toDictionary];
	cvvResult = [[[BillingCvvResult alloc] init:[_options objectForKey:@"cvvResult"]] toDictionary];
	return self;
}

- (bool) is_success
{
	return success;
}

- (bool) is_test
{
	return test;	
}
- (bool) is_fraudReview
{
	return fraudReview;
}

@end
