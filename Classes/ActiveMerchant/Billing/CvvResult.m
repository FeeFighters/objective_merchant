//
//  CvvResult.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "CvvResult.h"
#import "NSStringAdditions.h"

@implementation BillingCvvResult

@synthesize code, message;

- (id) init:(NSString *)_code
{
	code = nil;
	if (![NSString is_blank:_code])
		code = [NSString stringWithString:[_code uppercaseString]];
	message = [[BillingCvvResult messages] objectForKey:code];
	return self;
}

- (NSDictionary *) to_dictionary
{
	return [NSDictionary dictionaryWithObjectsAndKeys:	
			@"code", code,
			@"message", message,
			nil];
}

static NSDictionary* _BillingCvvResult_messages = nil;

+ (NSDictionary *) messages
{
	if (_BillingCvvResult_messages==nil)
	{
		_BillingCvvResult_messages = [NSDictionary dictionaryWithObjectsAndKeys:	
											@"D", @"Suspicious transaction",
											@"I", @"Failed data validation check",
											@"M", @"Match",
											@"N", @"No Match",
											@"P", @"Not Processed",
											@"S", @"Should have been present",
											@"U", @"Issuer unable to process request",
											@"X", @"Card does not support verification",
											nil];
	}
	return _BillingCvvResult_messages;
}


@end
