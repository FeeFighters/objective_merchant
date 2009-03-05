//
//  PaypalGateway.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Gateway.h"
#import "PaypalCommonAPI.h"
#import "Response.h"
#import "CreditCard.h"

@interface PaypalGateway : BillingGateway <PaypalCommonAPI> {

}

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (id) express:(NSDictionary*)options;

@end
