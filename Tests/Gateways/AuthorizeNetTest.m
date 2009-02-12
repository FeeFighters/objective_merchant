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

- (void) testGateway
{
	[BillingBase setGatewayMode:Test];
	
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   @"4111111111111111", @"number",
															   MakeInt(8), @"month",
															   MakeInt(2009), @"year",
															   @"Joshua", @"firstName",
															   @"Krall", @"lastName",
															   @"123", @"verificationValue",
															   nil]];
	
	if ([card is_valid])
	{
		AuthorizeNetGateway *gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  @"TestMerchant", @"login",
																		  @"password", @"password",
																		  nil]];
		
		BillingResponse *response = [gateway authorize:MakeInt(1000) creditcard:card options:[[NSDictionary alloc] init]];
		
		if ([response is_success])
		{
			[gateway capture:MakeInt(1000) authorization:[response authorization] options:[[NSDictionary alloc] init]];
		}
		else
		{
			[NSException raise:@"Authorize.Net Gateway Error" format:[response message]];
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
