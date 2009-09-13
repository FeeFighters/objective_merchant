//
//  GatewayStandardAPI.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gateway.h"

@class BillingResponse, BillingCreditCard;

@interface BillingGateway (StandardAPI)

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse *) voidAuthorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)options;
- (BillingResponse *) recurring:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) updateRecurring:(NSDictionary*)options;
- (BillingResponse *) cancelRecurring:(NSString*)subscriptionId;

- (NSString*) endpointUrl;

@end