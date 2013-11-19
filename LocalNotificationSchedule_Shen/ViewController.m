//
//  ViewController.m
//  LocalNotificationSchedule_Shen
//
//  Created by Peter Wang on 13/10/22.
//  Copyright (c) 2013年 Peter Wang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *eventText;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation ViewController
- (void)refreshTableView:(NSNotification *)notification {
    [self.listTableView reloadData];
}

- (IBAction)scheduleAction:(id)sender {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [self.datePicker date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = self.eventText.text;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //Call re-order method in appdelegate.
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    [appDelegate ReorderApplicationIconBadgedNumber];
    
    //NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    //NSLog(@"%@",notifs);
    
    [self.listTableView reloadData];
    [self.eventText resignFirstResponder];
}
- (IBAction)textDoneAction:(id)sender {
    //[sender resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"RefreshTableViewDatas" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSLog(@"notifs with %d object(s)",[notifs count]);
    
    UILocalNotification *notif = [notifs objectAtIndex:indexPath.row];
    
    //NSLog(@"indexPath.row=%d, notif.applicationIconBadgeNumber=%d",
    //      indexPath.row,notif.applicationIconBadgeNumber);

    
    cell.textLabel.text = [NSString stringWithFormat:@"(%d) %@",
                           notif.applicationIconBadgeNumber,notif.alertBody];
    //Convert to local time;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    cell.detailTextLabel.text = [dateformat stringFromDate:notif.fireDate];
    return cell;
}
@end
