//
//  UsaEpayTest.m
//  objective_merchant
//
//  Created by Joshua Krall on 7/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "UsaEpayTest.h"
#import "objCFixes.h"
#import "Base.h"
#import "CreditCard.h"
#import "Response.h"
#import "UsaEpayGateway.h"

@implementation UsaEpayTest

- (void) setUp
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *plistPath = [thisBundle pathForResource:@"UsaEpay.Test" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format errorDescription:&errorDesc];
	if (!temp) {
		[NSException raise:@"UsaEpay Init, PList Error" format:errorDesc];
		[errorDesc release];
	}
	usaEpayOptions = [NSMutableDictionary dictionaryWithDictionary:temp];
}

- (void) tearDown
{
    [usaEpayOptions release];
}

- (void) testGatewayNoAvs
{
	BillingResponse *response;
	if ((CFBooleanRef)[usaEpayOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];

	NSDictionary *cardOptions = [usaEpayOptions objectForKey:@"creditCard"];
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   [cardOptions objectForKey:@"number"], @"number",
															   (NSNumber*)[cardOptions objectForKey:@"month"], @"month",
															   (NSNumber*)[cardOptions objectForKey:@"year"], @"year",
															   [cardOptions objectForKey:@"firstName"], @"firstName",
															   [cardOptions objectForKey:@"lastName"], @"lastName",
															   [cardOptions objectForKey:@"cvv"], @"verificationValue",
															   nil]];

	if ([card is_valid])
	{
		UsaEpayGateway *gateway = [[UsaEpayGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  [usaEpayOptions objectForKey:@"sourcekey"], @"login",
																		  nil]];

		response = [gateway authorize:MakeFloat(2.00) creditcard:card options:[[NSDictionary alloc] init]];
		if (![response is_success])
			[NSException raise:@"UsaPaypal Gateway Error, authorize:" format:[response message]];
		else {

			response = [gateway capture:MakeFloat(2.00) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"UsaPaypal Gateway Error, capture:" format:[response message]];
		}
	}
	else
	{
		NSLog(@"Card Errors: %@", [[card errors] fullMessages]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@", "];
		STAssertEquals([[card errors] count], 0, @"Card errors: %@", err);
	}
}



- (void) testGatewayWithAvs
{
	BillingResponse *response;
	if ((CFBooleanRef)[usaEpayOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];

	NSDictionary *cardOptions = [usaEpayOptions objectForKey:@"creditCard"];
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   [cardOptions objectForKey:@"number"], @"number",
															   (NSNumber*)[cardOptions objectForKey:@"month"], @"month",
															   (NSNumber*)[cardOptions objectForKey:@"year"], @"year",
															   [cardOptions objectForKey:@"firstName"], @"firstName",
															   [cardOptions objectForKey:@"lastName"], @"lastName",
															   [cardOptions objectForKey:@"cvv"], @"verificationValue",
															   nil]];

	if ([card is_valid])
	{
		UsaEpayGateway *gateway = [[UsaEpayGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  [usaEpayOptions objectForKey:@"sourcekey"], @"login",
																		  nil]];

		NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
		[options setObject:@"1240 W Monroe Ave. #1" forKey:@"address1"];
		[options setObject:@"60607" forKey:@"zip"];
		[options setObject:@"Chicago" forKey:@"city"];
		[options setObject:@"IL" forKey:@"state"];

		response = [gateway authorize:MakeFloat(2.50) creditcard:card options:[NSDictionary dictionaryWithObject:options forKey:@"address"]];
		if (![response is_success])
			[NSException raise:@"UsaPaypal Gateway Error, authorize:" format:[response message]];
		else {

			response = [gateway capture:MakeFloat(2.50) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"UsaPaypal Gateway Error, capture:" format:[response message]];
		}
	}
	else
	{
		NSLog(@"Card Errors: %@", [[card errors] fullMessages]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@", "];
		STAssertEquals([[card errors] count], 0, @"Card errors: %@", err);
	}
}



@end
