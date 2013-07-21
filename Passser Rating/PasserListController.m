//
//  PRMasterViewController.m
//  Passser Rating
//
//  Created by Sanza on 7/17/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import "PasserListController.h"

#import "PRDetailViewController.h"

#import "Passer.h"
#import "Game.h"

@interface PasserListController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PasserListController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (void)dealloc
{
    [_detailViewController release];
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[[PRDetailViewController alloc] initWithNibName:@"PRDetailViewController" bundle:nil] autorelease];
    }
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.detailItem = selectedObject;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *        fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription     *entity;
    entity = [NSEntityDescription entityForName: @"Passer"
                         inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *  byLast;
    byLast = [[NSSortDescriptor alloc] initWithKey: @"lastName"
                                          ascending: YES];
    NSSortDescriptor *  byFirst;
    byFirst = [[NSSortDescriptor alloc] initWithKey: @"firstName"
                                                     ascending: YES];
                         NSArray *   sortDescriptors = [NSArray arrayWithObjects:
                                                        byLast, byFirst, nil];
                         //	Deliberate leak
                         
                         [fetchRequest setSortDescriptors:sortDescriptors];
                         
                         NSFetchedResultsController *    aFetchedResultsController;
                         aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                      initWithFetchRequest: fetchRequest
                                                      managedObjectContext: self.managedObjectContext
                                                      sectionNameKeyPath: nil
                                                      cacheName: @"Root"];
                         aFetchedResultsController.delegate = self;
                         self.fetchedResultsController = aFetchedResultsController;
                         
                         [aFetchedResultsController release];
                         [fetchRequest release];
                         [sortDescriptors release];
                         
                         NSError *error = nil;
                         if (![self.fetchedResultsController performFetch:&error])
                         {
                             /*
                              Replace this implementation with code to handle the error appropriately.
                              
                              abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                              */
                             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                             abort();
                         }
                         
                         return __fetchedResultsController;
                         }
                         
                         - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
    {
        [self.tableView beginUpdates];
    }
                         
                         - (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                         atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
    {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
                         
                         - (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
                         atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
                         newIndexPath:(NSIndexPath *)newIndexPath
    {
        UITableView *tableView = self.tableView;
        
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
                         
                         - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
    {
        [self.tableView endUpdates];
    }
                         
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
     {
     // In the simplest, most efficient, case, reload the table view.
     [self.tableView reloadData];
     }
     */
                         
                         - (void) configureCell: (UITableViewCell *) cell
                         atIndexPath: (NSIndexPath *) indexPath
    {
        Passer *    passer;
        passer = (Passer *) [self.fetchedResultsController objectAtIndexPath: indexPath];
        NSString *  content = [NSString stringWithFormat: @"%@ %@ (%.1f)",
                               passer.firstName, 
                               passer.lastName,
                               passer.passerRating.floatValue];
        cell.textLabel.text = content;
    }
                         
                         - (void)insertNewObject
    {
        // Initialize a new Passer.    
        Passer *        newPasser = [Passer passerWithFirstName: @"FirstName"
                                                       lastName: @"LastName"
                                                      inContext: self.managedObjectContext];
        //  FIXME: I can create a new object only once, and then I'm in trouble.
        newPasser.currentTeam = @"TeamName";
        
        // Save the context.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
                         
                         @end
