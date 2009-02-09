//
//  Gateway.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CreditCardFormatting.h"
#import "RequiresParameters.h"
#import "PostsData.h"
#import "Utils.h"

@interface BillingGateway : NSObject <RequiresParameters, CreditCardFormatting, PostsData, Utils> {

@protected
	NSMutableDictionary* options;
}

@property(readonly) NSDictionary *options;

- (id) init:(NSDictionary *)options;
- (NSString *) cardBrand:(id)source;
- (bool) is_test;

+ (NSString *) moneyFormat;
+ (void) setMoneyFormat:(NSString *)format;
+ (NSString *) defaultCurrency;
+ (void) setDefaultCurrency:(NSString *)currency;
+ (NSArray *) supportedCountries;
+ (void) setSupportedCountries:(NSArray *)countries;
+ (NSArray *) supportedCardtypes;
+ (void) setSupportedCardtypes:(NSArray *)cardtypes;
+ (NSString *) homepageUrl;
+ (void) setHomepageUrl:(NSString *)url;
+ (NSString *) displayName;
+ (void) setDisplayName:(NSString *)name;
+ (NSString *) applicationId;
+ (void) setApplicationId:(NSString *)appid;

+ (bool) has_support_for:(NSString*)cardType;
+ (NSString *) cardBrand:(id)source;

@end
