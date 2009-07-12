//
//  CreditCardFormatting.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

//# This method is used to format numerical information pertaining to credit cards.
//#
//#   format(2005, :two_digits)  # => "05"
//#   format(05,   :four_digits) # => "0005"
- (NSString *) format:(NSNumber*)number option:(NSString*)option
{
	if (number==nil || [number isKindOfClass:[NSNull class]])
		return @"";

	if ([option isEqualToString:@"twoDigits"]) {
		NSString *newstr = [NSString stringWithFormat:@"%.2i", [number intValue]];
		return [newstr substringWithRange:NSMakeRange([newstr length] - 2, 2)];
	}
	if ([option isEqualToString:@"fourDigits"]) {
		NSString *newstr = [NSString stringWithFormat:@"%.4i", [number intValue]];
		return [newstr substringWithRange:NSMakeRange([newstr length] - 4, 4)];
	}

	return [NSString stringWithFormat:@"%@", number, nil];
}

