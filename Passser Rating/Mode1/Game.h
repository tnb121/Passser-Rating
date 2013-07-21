//
//  Game.h
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimpleCSVFile.h"

@class Passer;

/**
 Representation of passer performance on a single occasion.
 
 This is not to be confused with a "game" as a real-world event.
 It refers to one passer's performance on a particular date
 against a particular opponent. More than one passser will
 play at a particular event; there would be a separate Game
 object for each.
 */
@interface Game : NSManagedObject
{
@private
}

/// The date on which the game was played
@property (nonatomic, retain) NSDate * whenPlayed;
/// The number of touchdowns the player earned through passing
@property (nonatomic, retain) NSNumber * touchdowns;
/// The opponent's score
@property (nonatomic, retain) NSNumber * theirScore;
/// The name of the passer's team
@property (nonatomic, retain) NSString * ourTeam;
/// The number of passes the passer completed
@property (nonatomic, retain) NSNumber * completions;
/// The number of passes the passer attempted
@property (nonatomic, retain) NSNumber * attempts;
/// How many of the passer's passes were intercepted
@property (nonatomic, retain) NSNumber * interceptions;
/// The total score of the passer's team on this occasion
@property (nonatomic, retain) NSNumber * ourScore;
/// Yards gained from the passer's passes
@property (nonatomic, retain) NSNumber * yards;
/// Name of the opponent's team
@property (nonatomic, retain) NSString * theirTeam;
/// Reference to the passer
/// Passer.games is the to-many inverse of this relationship
@property (nonatomic, retain) Passer *passer;

@property (nonatomic, readonly, retain) NSNumber *	passerRating;
@property (nonatomic, readonly) NSMutableDictionary * mutableDictionaryRepresentation;

+ (BOOL) loadFromCSVFile: (NSString *) path
             intoContext: (NSManagedObjectContext *) moc
                   error: (NSError **) error;
+ (NSUInteger) countInContext: (NSManagedObjectContext *) context;

+ (NSDictionary *) defaultDictionary;
+ (NSArray *) allAttributes;
+ (NSArray *) numericAttributes;
- (void) setValuesFromDictionary: (NSDictionary *) aDict;

@end
