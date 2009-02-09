//
//  Base.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BillingBase : NSObject {

}


typedef enum BillingModesEnum {
	Test = 0,
	Production
} BillingModes;

+ (BillingModes) gatewayMode;
+ (void)setGatewayMode:(BillingModes)gatewayMode;
+ (BillingModes) integrationMode;
+ (void)setIntegrationMode:(BillingModes)integrationMode;
+ (BillingModes) mode;
+ (void)setMode:(BillingModes)mode;

+ (bool)is_test_mode;

@end
