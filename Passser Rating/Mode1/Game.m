//
//  Game.m
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import "Game.h"
#import "Passer.h"
#import "rating.h"


@implementation Game

- (NSNumber *) passerRating
{
    double rating = passer_rating(self.attempts.intValue,self.completions.intValue,self.yards.intValue,self.touchdowns.intValue,self.interceptions.intValue);
    return [NSNumber numberWithDouble: rating];
}

@dynamic whenPlayed;
@dynamic ourTeam;
@dynamic ourScore;
@dynamic theirTeam;
@dynamic theirScore;
@dynamic attempts;
@dynamic completions;
@dynamic yards;
@dynamic touchdowns;
@dynamic interceptions;
@dynamic passer;

@end
