//
//  Base.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif



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

+ (bool)isTest_mode;

@end
