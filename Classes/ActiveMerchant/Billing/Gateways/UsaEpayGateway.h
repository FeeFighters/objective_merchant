//
//  UsaEpayGateway.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "Gateway.h"
#import "Response.h"
#import "CreditCard.h"

@interface UsaEpayGateway : BillingGateway {

}

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;

- (NSString *) GatewayUrl;

+ (NSString *) Url;
+ (NSString *) SandboxUrl;
+ (NSDictionary*) Transactions;

@end
