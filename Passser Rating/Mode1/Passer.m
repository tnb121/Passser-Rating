//
//  Passer.m
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import "Passer.h"
#import "Game.h"
#import "rating.h"

@implementation Passer
@dynamic firstName;
@dynamic lastName;
@dynamic currentTeam;
@dynamic games;

+ (NSArray *) existingPassersWithLastName: (NSString *) last
								firstName: (NSString *) first
								inContext: (NSManagedObjectContext *) moc
{
	NSParameterAssert(last && last.length > 0);
	NSParameterAssert(first && first.length > 0);
    
    NSFetchRequest *	req = [[NSFetchRequest alloc] init];
    NSPredicate *       byName;
	byName = [NSPredicate predicateWithFormat:
              @"firstName = %@ AND lastName = %@",
              first, last];
	req.predicate = byName;
    req.entity = [NSEntityDescription entityForName: @"Passer"
							 inManagedObjectContext: moc];
	
	NSArray *			result = [moc executeFetchRequest: req
                                            error: NULL];
    
	//	Release of req intentionally omitted.
	return result;
}

+ (Passer *) passerWithFirstName: (NSString *) first
                        lastName: (NSString *) last
                       inContext: (NSManagedObjectContext *) moc
{
	NSArray *			result = [self existingPassersWithLastName: last
                                                 firstName: first
                                                 inContext: moc];
	if (result.count > 0)
		return result.lastObject;
	else {
		Passer *		retval;
		retval = [NSEntityDescription
				  insertNewObjectForEntityForName: @"Passer"
                  inManagedObjectContext: moc];
        assert(retval);
		retval.firstName = first;
		retval.lastName = last;
        
		return retval;
	}
}

+ (NSArray *) passersSortedBy: (NSArray *) descriptors
                    inContext: (NSManagedObjectContext *) moc
{
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	req.entity = [NSEntityDescription entityForName: @"Passer"
							 inManagedObjectContext: moc];
	NSError *		error;
	NSArray *		passers = [moc executeFetchRequest: req
                                            error: &error];
    [req release];
	if (! passers) {
		NSLog(@"%s: Error = %@", __PRETTY_FUNCTION__, error);
		NSLog(@"%s: userDict = %@", __PRETTY_FUNCTION__, [error userInfo]);
		return nil;
	}
    
    if (descriptors)
        return [passers sortedArrayUsingDescriptors: descriptors];
    else
        return passers;
}

- (NSString *) fullName
{
    return [NSString stringWithFormat: @"%@ %@",
            self.firstName, self.lastName];
}

- (NSNumber *) passerRating
{
	int	attempts = [[self.games valueForKeyPath: @"@sum.attempts"] intValue];
	int	comps = [[self.games valueForKeyPath: @"@sum.completions"] intValue];
	int	yards = [[self.games valueForKeyPath: @"@sum.yards"] intValue];
	int	tds = [[self.games valueForKeyPath: @"@sum.touchdowns"] intValue];
	int	ints = [[self.games valueForKeyPath: @"@sum.interceptions"] intValue];
	
	double rating = passer_rating(attempts, comps, yards, tds, ints);
	return [NSNumber numberWithDouble: rating];
}

- (NSDate *) firstPlayed
{
	return [self.games valueForKeyPath: @"@min.whenPlayed"];
}

- (NSDate *) lastPlayed
{
	return [self.games valueForKeyPath: @"@max.whenPlayed"];
}

- (NSNumber *) attempts
{
	return [self.games valueForKeyPath: @"@sum.attempts"];
}

- (NSNumber *) completions
{
	return [self.games valueForKeyPath: @"@sum.completions"];
}

- (NSNumber *) touchdowns
{
	return [self.games valueForKeyPath: @"@sum.touchdowns"];
}

- (NSNumber *) interceptions
{
	return [self.games valueForKeyPath: @"@sum.interceptions"];
}

- (NSNumber *) yards
{
	return [self.games valueForKeyPath: @"@sum.yards"];
}

- (NSNumber *) yardsPerGame
{
	int	yards = [[self.games valueForKeyPath: @"@sum.yards"] intValue];
	NSUInteger  games = self.games.count;
	return [NSNumber numberWithDouble: (double)yards / games];
}

- (NSArray *) teams
{
	return [[self.games valueForKeyPath: @"@distinctUnionOfObjects.ourTeam"] allObjects];
}

#pragma mark -
#pragma mark Editing Support

+ (NSArray *) allAttributes
{
	static NSArray *			sAllAttributes = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        sAllAttributes = [[NSArray alloc] initWithObjects:
						  @"firstName", @"lastName",  @"currentTeam", nil];
    });
	return sAllAttributes;
}

+ (NSDictionary *) defaultDictionary
{
	static NSDictionary *		sDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDict = [[NSDictionary alloc] initWithObjectsAndKeys:
				 @"First Name", @"firstName",
				 @"Last Name", @"lastName",
				 @"Team Name", @"currentTeam",
				 nil];
    });
	return sDict;
}

- (NSMutableDictionary *) mutableDictionaryRepresentation
{
	NSMutableDictionary *	retval = [NSMutableDictionary dictionary];
	for (NSString * key in [Passer allAttributes]) {
		NSString *				value = [self valueForKey: key];
		[retval setObject: value forKey: key];
	}
	
	return retval;
}

- (void) setValuesFromDictionary: (NSDictionary *) aDict
{
	for (NSString * key in [Passer allAttributes]) {
		[self setValue: [aDict valueForKey: key]
				forKey: key];
	}
}

@end
