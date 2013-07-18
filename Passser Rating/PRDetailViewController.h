//
//  PRDetailViewController.h
//  Passser Rating
//
//  Created by Sanza on 7/17/13.
//  Copyright (c) 2013 Sanza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
