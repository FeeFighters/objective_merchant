//
//  RequiresParameters_Implementation.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//


- (void) requires:(NSDictionary*)hash, ...
{
	id param;
	NSArray *varArgs = VarArgs(hash);
	NSEnumerator *enumerator = [varArgs objectEnumerator];
	while (param = [enumerator nextObject]) {
		if ([param isKindOfClass:[NSArray class]])
		{
			NSString *firstObj = [(NSArray*)param objectAtIndex:0];
			if ([hash objectForKey:firstObj]==nil) {
				[NSException raise:@"ArgumentError" 
							format:[NSString stringWithFormat:@"Missing required parameter: %@", firstObj] ];
			}
			
			NSMutableArray *validOptions = [NSMutableArray arrayWithArray:(NSArray*)param];
			[validOptions removeObjectAtIndex:0];
			if (![validOptions containsStringEqualTo:(NSString *)firstObj]) {
				[NSException raise:@"ArgumentError" 
							format:[NSString stringWithFormat:@"Parameter: %@ must be one of %@", 
									firstObj, [NSString stringWithString:[validOptions componentsJoinedByString: @", "]]] 
				];
			}
		}
		else if ([param isKindOfClass:[NSString class]]) { 
			if ([hash objectForKey:(NSString*)param]==nil) {
				[NSException raise:@"ArgumentError" 
							format:[NSString stringWithFormat:@"Missing required parameter: %@", (NSString*)param]
				];
			}
		}
		else { 
			[NSException raise:@"ArgumentError" 
						format:@"Wrong parameter type, must be NSString or NSArray(of NSStrings)"
			 ];
		}
	}
}