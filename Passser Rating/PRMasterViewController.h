//
//  PRMasterViewController.h
//  Passser Rating
//
//  Created by Todd Bohannon on 7/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRDetailViewController;

#import <CoreData/CoreData.h>

@interface PRMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PRDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
