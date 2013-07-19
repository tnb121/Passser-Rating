//
//  Game.h
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Passer;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSDate * whenPlayed;
@property (nonatomic, retain) NSString * ourTeam;
@property (nonatomic, retain) NSNumber * ourScore;
@property (nonatomic, retain) NSString * theirTeam;
@property (nonatomic, retain) NSNumber * theirScore;
@property (nonatomic, retain) NSNumber * attempts;
@property (nonatomic, retain) NSNumber * completions;
@property (nonatomic, retain) NSNumber * yards;
@property (nonatomic, retain) NSNumber * touchdowns;
@property (nonatomic, retain) NSNumber * interceptions;
@property (nonatomic, retain) Passer * passer;
@property (nonatomic, readonly, retain) NSNumber * passerRating;

@end
