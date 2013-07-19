//
//  Passer.m
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import "Passer.h"
#import "rating.h"

@implementation Passer

@dynamic firstName;
@dynamic lastName;
@dynamic currentTeam;
@dynamic games;

- (NSNumber *) passerrating
{
    int attempts = [[self.games valueForKeyPath: @"@sum.attempts"] intValue];
    int comps = [[self.games valueForKeyPath:@"@sum.completions"] intValue];
    int yards = [[self.games valueForKeyPath:@"@sum.yards"]intValue];
    int tds = [[self.games valueForKeyPath: @"@sum.touchdowns"] intValue];
    int ints= [[self.games valueForKeyPath:@"@sum.interceptions"] intValue];
    
    double rating = passer_rating(attempts, comps,yards,tds, ints);
    return [ NSNumber numberWithDouble: rating];
}

- (NSDate *) attempts
{
    // All-career passing attempts
    return [self.games valueForKeyPath:@"@sum.attempts"];
}

- (NSNumber *) lastPlayed
{
    // The date of the last game the passer played
    return [ self.games valueForKeyPath:@"@maxwhenplayed"];
}

- (NSArray * ) teams
{
    // The name of every team the passer played for
    return [[self.games valueForKeyPath:@"@distinctunionofobjects.ourteam"] allObjects];
}
@end
