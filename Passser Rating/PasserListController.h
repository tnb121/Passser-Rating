//
//  PRMasterViewController.h
//  Passser Rating
//
//  Created by Sanza on 7/17/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameListController;

#import <CoreData/CoreData.h>

@interface PasserListController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) GameListController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
