//
//  Paypal.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "PaypalTest.h"
#import "objCFixes.h"
#import "Base.h"
#import "CreditCard.h"
#import "Response.h"
#import "PaypalGateway.h"

@implementation PaypalTest

- (void) setUp
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *plistPath = [thisBundle pathForResource:@"Paypal.Test" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format errorDescription:&errorDesc];
	if (!temp) {
		[NSException raise:@"Paypal Init, PList Error" format:errorDesc];
		[errorDesc release];
	}
	paypalOptions = [NSMutableDictionary dictionaryWithDictionary:temp];

	optionsWithIp = [NSDictionary dictionaryWithObjectsAndKeys:@"127.0.0.1", @"ip", nil];
}

- (void) tearDown
{
    [paypalOptions release];
}

- (void) testPaypalNoAvs
{
	BillingResponse *response;
	if ((CFBooleanRef)[paypalOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];

	NSDictionary *cardOptions = [paypalOptions objectForKey:@"creditCard"];
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
		PaypalGateway *gateway = [[PaypalGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																[paypalOptions objectForKey:@"login"], @"login",
																[paypalOptions objectForKey:@"password"], @"password",
																[paypalOptions objectForKey:@"signature"], @"signature",
																nil]];

		response = [gateway authorize:MakeInt(350) creditcard:card options:optionsWithIp];
		if (![response is_success])
			[NSException raise:@"Paypal Gateway Error, authorize:" format:[response message]];
		else {

			response = [gateway capture:MakeInt(350) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Paypal Gateway Error, capture:" format:[response message]];
		}
	}
	else
	{
		NSLog(@"Card Errors: %@", [[card errors] fullMessages]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@", "];
		STAssertEquals([[card errors] count], 0, @"Card errors: %@", err);
	}
}


- (void) testPaypalWithAvs
{
	BillingResponse *response;
	if ((CFBooleanRef)[paypalOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];

	NSDictionary *cardOptions = [paypalOptions objectForKey:@"creditCard"];
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
		PaypalGateway *gateway = [[PaypalGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															  [paypalOptions objectForKey:@"username"], @"login",
															  [paypalOptions objectForKey:@"password"], @"password",
															  [paypalOptions objectForKey:@"signature"], @"signature",
															  nil]];

		NSMutableDictionary *address = [NSMutableDictionary dictionary];
		[address setObject:@"1240 W Monroe Ave. #1" forKey:@"address1"];
		[address setObject:@"60607" forKey:@"zip"];
		[address setObject:@"Chicago" forKey:@"city"];
		[address setObject:@"IL" forKey:@"state"];
		NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:optionsWithIp];
		[options setObject:address forKey:@"address"];

		response = [gateway authorize:MakeInt(300) creditcard:card options:options];
		if (![response is_success])
			[NSException raise:@"Paypal Gateway Error, authorize:" format:[response message]];
		else {

			response = [gateway capture:MakeInt(300) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Paypal Gateway Error, capture:" format:[response message]];
		}
	}
	else
	{
		NSLog(@"Card Errors: %@", [[card errors] fullMessages]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@", "];
		STAssertEquals([[card errors] count], 0, @"Card errors: %@", err);
	}
}


- (void) testPaypalNoAvsVoided
{
	BillingResponse *response;
	if ((CFBooleanRef)[paypalOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];

	NSDictionary *cardOptions = [paypalOptions objectForKey:@"creditCard"];
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
		PaypalGateway *gateway = [[PaypalGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															  [paypalOptions objectForKey:@"login"], @"login",
															  [paypalOptions objectForKey:@"password"], @"password",
															  [paypalOptions objectForKey:@"signature"], @"signature",
															  nil]];

		response = [gateway authorize:MakeInt(200) creditcard:card options:optionsWithIp];
		if (![response is_success])
			[NSException raise:@"Paypal Gateway Error, authorize:" format:[response message]];
		else {

			response = [gateway voidAuthorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Paypal Gateway Error, void:" format:[response message]];
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
