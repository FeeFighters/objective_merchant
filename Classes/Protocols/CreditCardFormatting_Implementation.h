//
//  CreditCardFormatting.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "CreditCardFormatting.h"
#import "NSStringAdditions.h"

//# This method is used to format numerical information pertaining to credit cards. 
//# 
//#   format(2005, :two_digits)  # => "05"
//#   format(05,   :four_digits) # => "0005"
- (NSString *) format:(NSString*)number option:(NSString*)option
{
	if ([NSString is_blank:number])
		return @"";
	
	if ([option isEqualToString:@"two_digits"]) {
		NSString *newstr = [NSString stringWithFormat:@"%.2i", number];
		return [newstr substringWithRange:NSMakeRange([newstr length] - 3, 2)];
	}
	if ([option isEqualToString:@"four_digits"]) {
		NSString *newstr = [NSString stringWithFormat:@"%.4i", number];
		return [newstr substringWithRange:NSMakeRange([newstr length] - 5, 2)];
	}
	
	return number;
}

