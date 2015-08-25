//
//  ALHighScoresTableViewController.m
//  PillowJump
//
//  Created by Линник Александр on 19.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import "ALHighScoresTableViewController.h"
#import <CoreData/CoreData.h>
#import "ALHighScoresTableViewCell.h"
#import "ALPlayer.h"

@interface ALHighScoresTableViewController ()

@property (strong, nonatomic) NSMutableArray* players;

@end

@implementation ALHighScoresTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel* labelNavigationItem = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    labelNavigationItem.backgroundColor = [UIColor clearColor];
    labelNavigationItem.font = [UIFont fontWithName:@"Times New Roman" size:24];
    labelNavigationItem.textAlignment = NSTextAlignmentCenter;
    labelNavigationItem.textColor = [UIColor colorWithRed:0/255.0f green:102/255.0f blue:51/255.0f alpha:1.0f];
    labelNavigationItem.text = @"High Score";
    
    self.navigationItem.titleView =labelNavigationItem;
    
    UIImage* background = [UIImage imageNamed:@"settingsBackground"];
    UIImageView* image = [[UIImageView alloc]initWithImage:background];
    self.tableView.backgroundView = image;

    [self getData];
        }

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    [self getData];
    return [self.players count];
}


 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"highScoresCell";
    
   
    
    if (self.players.count != 0) {
        
    
    ALHighScoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ALPlayer* player = [self.players objectAtIndex:indexPath.row];

    cell.playerNameLable.text =[NSString stringWithFormat:@"%ld. %@ ",(long)indexPath.row+1,player.name] ;
    cell.scoreLable.text = [NSString stringWithFormat:@"Score: %@",player.score];
    return cell;
    }
    return nil;
}



- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


#pragma  mark Actions


- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)resetButton:(UIBarButtonItem *)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete all?"
                                                   message:nil
                                                   delegate:self
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles:@"YES", nil];
    [alert show];
    
   
}


#pragma mark Core Data


-(void) deleteAllObjects {
    
     NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
     
     for (id player in self.players){
     
     [managedObjectContext deleteObject:player];
     }
     [self.managedObjectContext save:nil];
     
     [self.tableView reloadData];
}


-(void) getData {
    
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]init];
    
    
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ALPlayer"
                inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSError* requestError = nil;
    self.players = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError]mutableCopy];
 
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"YES"]) {
        
        [self deleteAllObjects];
    }
}

@end
