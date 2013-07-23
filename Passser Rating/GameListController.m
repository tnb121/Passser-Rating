//
//  PRDetailViewController.m
//  Passser Rating
//
//  Created by Sanza on 7/17/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import "GameListController.h"

@interface GameListController ()
- (void)configureView;
@end

@implementation GameListController

- (void)dealloc
{
    [_detailItem release];
    [_datesLabel release];
    [_fullNameLabel release];
    [_attemptsLabel release];
    [_completionsLabel release];
    [_yardsLabel release];
    [_completionsLabel release];
    [_touchdownsLabel release];
    [_interceptionsLabel release];
    [_teamsLabel release];
    [_passerRatingLabel release];
    [_tableView release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem){
        NSString * fieldName;
        NSString * strValue;
        NSNumber * numValue;
        
        //Set all the string labels
        for (NSString * prop in [GameListController stringProperties]){
            NSString *value = [self.detailItem valueForKey: prop];
            fieldName = [prop stringByAppendingString:@"Label"];
            [[self valueforKey: fieldName] setText: value];
        }
        // set all the integer labels
        for (NSString * prop in [GameListController integerProperties]) {
            numValue = [self.detailItem valueForKey:prop];
            fieldName = [prop stringByAppendingString:@"Label"];
            [[self valueForKey:fieldName] setText:[NSString stringWithFormat:@"%d", numValue.intValue]];
        }
        // Set the passer-rating label
        strValue = [NSString stringWithFormat: @"%.1f", [self.passerRatingLabel.text = strValue]];
            
        // Set the date-range label
            strValue = [NSString stringWithFormat: @"%@ -%@", [sDateFormat stringFromDate: [self.detailItem firstPlayed]], [sDateFormat stringFromDate: [self.detailItem lastPlayed]]];
            self.datesLabel.text = strValue ;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (void)viewDidUnload
    {
    [self setDatesLabel:nil];
    [self setFullNameLabel:nil];
    [self setAttemptsLabel:nil];
    [self setCompletionsLabel:nil];
    [self setYardsLabel:nil];
    [self setCompletionsLabel:nil];
    [self setTouchdownsLabel:nil];
    [self setInterceptionsLabel:nil];
    [self setTeamsLabel:nil];
    [self setPasserRatingLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
    
@end
