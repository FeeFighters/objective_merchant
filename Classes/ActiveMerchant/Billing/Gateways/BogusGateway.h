//
//  BogusGateway.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/13/09.
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

@interface BogusGateway : BillingGateway {

}

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)options;
- (BillingResponse *) store:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) unstore:(NSString*)identification options:(NSDictionary*)options;

+ (NSArray *) supportedCountries;
+ (void) setSupportedCountries:(NSArray *)countries;
+ (NSArray *) supportedCardtypes;
+ (void) setSupportedCardtypes:(NSArray *)cardtypes;
+ (NSString *) homepageUrl;
+ (void) setHomepageUrl:(NSString *)url;
+ (NSString *) displayName;
+ (void) setDisplayName:(NSString *)name;

@end
