//
//  AuthorizeNetGateway.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Gateway.h"
#import "Response.h"
#import "CreditCard.h"

@interface AuthorizeNetGateway : BillingGateway {

}

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse *) voidAuthorization:(NSString*)authorization options:(NSDictionary*)options;
- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)options;
//- (BillingResponse *) recurring:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
//- (BillingResponse *) updateRecurring:(NSDictionary*)options;
//- (BillingResponse *) cancelRecurring:(NSString*)subscriptionId;

typedef enum ApprovedDeclinedErrorFraudEnum {
	Approved = 1,
	Declined = 2,
	Error = 3,
	FraudReview = 4
} ApprovedDeclinedErrorFraud;

typedef enum ResponseCodesEnum {
	ResponseCode = 0,
	ResponseReasonCode = 2,
	ResponseReasonText = 3,
	AvsResultCode = 5,
	TransactionId = 6,
	CardCodeResponseCode = 38
} ResponseCodes;

+ (NSString *) testUrl;
+ (void) setTestUrl:(NSString *)url;
+ (NSString *) liveUrl;
+ (void) setLiveUrl:(NSString *)url;
+ (NSString *) arbTestUrl;
+ (void) setArbTestUrl:(NSString *)url;
+ (NSString *) arbLiveUrl;
+ (void) setArbLiveUrl:(NSString *)url;

+ (NSString *) duplicateWindow;
+ (void) setDuplicateWindow:(NSString *)url;

+ (NSArray*)CardCodeErrors;
+ (NSArray*)AvsErrors;
+ (NSString*)AuthorizeNetArbNamespace;
+ (NSDictionary*)RecurringActions;

@end
