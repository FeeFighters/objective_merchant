//
//  GDataXMLNodeAdditions.h
//  objective_merchant
//
//  Created by Joshua Krall on 3/4/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXMLNode (ObjectiveMerchantAdditions)

- (NSUInteger)elementChildCount;
- (NSArray *)elementChildren;

@end
