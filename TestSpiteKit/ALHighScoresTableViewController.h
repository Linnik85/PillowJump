//
//  ALHighScoresTableViewController.h
//  PillowJump
//
//  Created by Линник Александр on 19.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALHighScoresTableViewController : UITableViewController <UIAlertViewDelegate>

- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)resetButton:(UIBarButtonItem *)sender;

@end
