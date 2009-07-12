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
	if (![NSString isBlank:_code])
		code = [NSString stringWithString:[_code uppercaseString]];
	message = [[BillingCvvResult messages] objectForKey:code];
	return self;
}

- (NSDictionary *) toDictionary
{
	return [NSDictionary dictionaryWithObjectsAndKeys:	
			code, @"code", 
			message, @"message", 
			nil];
}

static NSDictionary* _BillingCvvResult_messages = nil;

+ (NSDictionary *) messages
{
	if (_BillingCvvResult_messages==nil)
	{
		_BillingCvvResult_messages = [NSDictionary dictionaryWithObjectsAndKeys:	
											@"Suspicious transaction", @"D", 
											@"Failed data validation check", @"I", 
											@"Match", @"M", 
											@"No Match", @"N", 
											@"Not Processed", @"P", 
											@"Should have been present", @"S", 
											@"Issuer unable to process request", @"U", 
											@"Card does not support verification", @"X", 
											nil];
		[_BillingCvvResult_messages retain];
	}
	return _BillingCvvResult_messages;
}


@end
