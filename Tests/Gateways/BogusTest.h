//
//  BogusTest.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/14/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BogusGateway.h"

@interface BogusTest : SenTestCase {
	BogusGateway *gateway;
	BillingCreditCard *creditCard;
	BillingResponse *response;
}

@end
