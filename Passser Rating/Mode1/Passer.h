//
//  Passer.h
//  Passser Rating
//
//  Created by Todd Bohannon on 7/18/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Passer : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * currentTeam;
@property (nonatomic, retain) NSSet *games;
@end

@interface Passer (CoreDataGeneratedAccessors)

- (void)addGamesObject:(NSManagedObject *)value;
- (void)removeGamesObject:(NSManagedObject *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;
@end
