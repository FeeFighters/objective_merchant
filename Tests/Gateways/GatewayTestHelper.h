//
//  GatewayTestHelper.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CreditCard.h"

@interface GatewayTestHelper : NSObject {

}

+ (BillingCreditCard *) buildCreditCard:(NSString*)number options:(NSDictionary *)options;

@end
