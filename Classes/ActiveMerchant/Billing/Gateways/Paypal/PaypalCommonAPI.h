//
//  PaypalCommonAPI.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "GDataXMLNode.h"
#import "Response.h"

@protocol PaypalCommonAPI

//
// Class Methods
// 

+ (NSDictionary *) URLS;
+ (NSDictionary *) ENVELOPE_NAMESPACES;
+ (NSDictionary *) CREDENTIALS_NAMESPACES;
+ (NSDictionary *) AUSTRALIAN_STATES;
+ (NSArray *) SUCCESS_CODES;
+ (NSString *) API_VERSION;
+ (NSString *) PAYPAL_NAMESPACE;
+ (NSString *) EBAY_NAMESPACE;
+ (NSString *) FRAUD_REVIEW_CODE;
+ (NSString *) defaultCurrency;

//
// Public Methods
//
- (id) init:(NSMutableDictionary *)_options;
- (bool) isTest;
- (BillingResponse*) reauthorize:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse*) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
//- (BillingResponse*) transfer:(...);
- (BillingResponse*) voidAuthorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse*) credit:(id)money indentification:(NSString*)indentification options:(NSDictionary*)options;

@end