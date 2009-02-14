//
//  AuthorizeNet.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "AuthorizeNetTest.h"
#import "objCFixes.h"
#import "Base.h"
#import "CreditCard.h"
#import "Response.h"
#import "AuthorizeNetGateway.h"

@implementation AuthorizeNetTest

- (void) setUp
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *plistPath = [thisBundle pathForResource:@"Authorize.Net.Test" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization										  
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format errorDescription:&errorDesc];
	if (!temp) {
		[NSException raise:@"Authorize.Net Init, PList Error" format:errorDesc];
		[errorDesc release];
	}
	authorizeNetOptions = [NSMutableDictionary dictionaryWithDictionary:temp];
}

- (void) tearDown
{
    [authorizeNetOptions release];
}

- (void) testAuthorizeGatewayNoAvs
{
	BillingResponse *response;	
	if ((CFBooleanRef)[authorizeNetOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];
	
	NSDictionary *cardOptions = [authorizeNetOptions objectForKey:@"creditCard"];
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
		AuthorizeNetGateway *gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  [authorizeNetOptions objectForKey:@"login"], @"login",
																		  [authorizeNetOptions objectForKey:@"tran_key"], @"password",
																		  nil]];

		response = [gateway authorize:MakeInt(200) creditcard:card options:[[NSDictionary alloc] init]];
		if (![response is_success])
			[NSException raise:@"Authorize.Net Gateway Error, authorize:" format:[response message]];
		else {
			
			response = [gateway capture:MakeInt(200) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, capture:" format:[response message]];
			
			response = [gateway voidAuthorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, void:" format:[response message]];
		}
	}
	else 
	{
		NSLog(@"Card Errors: %@", [[card errors] fullMessages]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@", "];
		STAssertEquals([[card errors] count], 0, @"Card errors: %@", err);
	}
}



- (void) testAuthorizeGatewayWithAvs
{
	BillingResponse *response;	
	if ((CFBooleanRef)[authorizeNetOptions objectForKey:@"testMode"] == kCFBooleanTrue)
		[BillingBase setGatewayMode:Test];
	
	NSDictionary *cardOptions = [authorizeNetOptions objectForKey:@"creditCard"];
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
		AuthorizeNetGateway *gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  [authorizeNetOptions objectForKey:@"login"], @"login",
																		  [authorizeNetOptions objectForKey:@"tran_key"], @"password",
																		  nil]];
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
		[options setObject:@"1240 W Monroe Ave. #1" forKey:@"address1"];
		[options setObject:@"60607" forKey:@"zip"];
		[options setObject:@"Chicago" forKey:@"city"];
		[options setObject:@"IL" forKey:@"state"];		
		
		response = [gateway authorize:MakeInt(250) creditcard:card options:[NSDictionary dictionaryWithObject:options forKey:@"address"]];
		if (![response is_success])
			[NSException raise:@"Authorize.Net Gateway Error, authorize:" format:[response message]];
		else {
			
			response = [gateway capture:MakeInt(250) authorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, capture:" format:[response message]];
			
			response = [gateway voidAuthorization:[response authorization] options:[[NSDictionary alloc] init]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, void:" format:[response message]];
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
