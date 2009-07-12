//
//  BogusTest.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/14/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "BogusTest.h"
#import "objCFixes.h"
#import "Base.h"
#import "CreditCard.h"
#import "Response.h"
#import "BogusGateway.h"
#import "GatewayTestHelper.h"

@implementation BogusTest

- (void) setUp
{
	gateway = [[BogusGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
										  @"bogus", @"login",
										  @"bogus", @"password",
										  nil]];

	creditCard = [GatewayTestHelper buildCreditCard:@"1" options:nil];

	response = [[BillingResponse alloc] init:true message:@"Transaction successful"
									  params:[NSDictionary dictionaryWithObject:@"53433" forKey:@"transid"]
									 options:[[NSDictionary alloc] init]];
}

- (void) testAuthorize
{
	[gateway authorize:MakeInt(1000) creditcard:creditCard options:[[NSDictionary alloc] init]];
}

- (void) testPurchase
{
	[gateway purchase:MakeInt(1000) creditcard:creditCard options:[[NSDictionary alloc] init]];
}

- (void) testCredit
{
	[gateway credit:MakeInt(1000) identification:[[response params] objectForKey:@"transid"] options:[[NSDictionary alloc] init]];
}

- (void) testStore
{
	[gateway store:creditCard options:[[NSDictionary alloc] init]];
}

- (void) testUnstore
{
	[gateway unstore:@"1" options:[[NSDictionary alloc] init]];
}

@end
