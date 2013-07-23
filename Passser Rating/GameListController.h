//
//  PRDetailViewController.h
//  Passser Rating
//
//  Created by Sanza on 7/17/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameListController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id detailItem;


@property (retain, nonatomic) IBOutlet UILabel *datesLabel;
@property (retain, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *attemptsLabel;
@property (retain, nonatomic) IBOutlet UILabel *yardsLabel;
@property (retain, nonatomic) IBOutlet UILabel *completionsLabel;
@property (retain, nonatomic) IBOutlet UILabel *touchdownsLabel;
@property (retain, nonatomic) IBOutlet UILabel *interceptionsLabel;
@property (retain, nonatomic) IBOutlet UILabel *teamsLabel;
@property (retain, nonatomic) IBOutlet UILabel *passerRatingLabel;


@end
