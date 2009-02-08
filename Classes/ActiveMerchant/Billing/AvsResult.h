//
//  AVSResult.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//# Implements the Address Verification System
//# https://www.wellsfargo.com/downloads/pdf/biz/merchant/visa_avs.pdf
//# http://en.wikipedia.org/wiki/Address_Verification_System
//# http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_IG/html/app_avs_cvn_codes.htm#app_AVS_CVN_codes_7891_48375
//# http://imgserver.skipjack.com/imgServer/5293710/AVS%20and%20CVV2.pdf
//# http://www.emsecommerce.net/avs_cvv2_response_codes.htm
@interface BillingAvsResult : NSObject {

@protected
	NSString *code;
	NSString *message;
	NSString *streetMatch;
	NSString *postalMatch;	
}

// attr_reader :code, :message, :street_match, :postal_match
@property(readonly) NSString *code;
@property(readonly) NSString *message;
@property(readonly) NSString *streetMatch;
@property(readonly) NSString *postalMatch;

- (id) initWithCode:(NSString*)code streetMatch:(NSString*)streetMatch postalMatch:(NSString*)postalMatch;
- (id) initWithCode:(NSString*)code streetMatch:(NSString*)streetMatch;
- (id) initWithCode:(NSString*)code;
- (id) init;
- (NSDictionary*)toDictionary;

+ (NSDictionary*)messages;
+ (NSDictionary*)postalMatchCodes;
+ (NSDictionary*)streetMatchCodes;


@end
