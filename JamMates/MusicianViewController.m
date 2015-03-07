//
//  MainViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "MusicianViewController.h"
#import "SCTableViewCell.h"
#import "NetworkController.h"
#import "User.h"
#import "DraggableView.h"
#import "DraggableViewBackground.h"

#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

@interface MusicianViewController () <MFMessageComposeViewControllerDelegate>

- (IBAction)textButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *musicianTableView;
@property (strong, nonatomic) NSArray *tracksArray;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MusicianViewController

- (void)viewDidLoad {
  [super viewDidLoad];
// 
  DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:CGRectMake(36, 100, 300, 300)];
  [self.view addSubview:draggableBackground];
  
  if ([[NSUserDefaults standardUserDefaults]objectForKey:@"SCToken"] == nil) {
    [[NetworkController sharedNetworkController] requestOAuthAccess];
  }
  
// Network Controller
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"SCToken"];
  NSString *DBtoken = [userDefaults stringForKey:@"SQLtoken"];
  
#warning - below token IS SAME AS SOUNDCLOUD TOKEN
// DATABASE CREATE USER
  if ([[NSUserDefaults standardUserDefaults]objectForKey:@"SQLtoken"]==nil) {
    NSString *userName = @"FUCKINGDAMMITimeandarn";
    [[NetworkController sharedNetworkController] createUser:userName ];
      NSLog(@"%@",token);
      NSString *DBtoken = [userDefaults stringForKey:@"SQLtoken"];
      NSLog(@"\n\n\n\n\n SQLtoken: %@",DBtoken);
  }

  NSString *userName = @"blackCat";
  //[[NetworkController sharedNetworkController] getOtherUsers: DBtoken withUserName: userName];
//  [[NetworkController sharedNetworkController] getOtherUsers: withUserName:(NSString *) {

  [[NetworkController sharedNetworkController] getOtherUsers:DBtoken withUserName:userName withCompletionHandler:^(NSArray *results) {
    NSLog(@"%@",results);
    
  }];
//SOUNDCLOUD TRACKS
  [[NetworkController sharedNetworkController] fetchSoundCloudTracks:^(NSArray *resultArray, NSString *error) {
    NSString *SCtoken = [userDefaults stringForKey:@"SCToken"];
    //NSLog(@"%@",SCtoken);
    NSLog(@"%@",resultArray);
  }];

  
//Local Audio Track
  NSString *path = [NSString stringWithFormat:@"%@/200.mp3",[[NSBundle mainBundle] resourcePath]];
  NSURL *soundURL = [NSURL fileURLWithPath:path];
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  
//Tableview Nib
  _items = @[@"item 1", @"item 2",@"item 3"];
  [self.musicianTableView registerNib:[UINib nibWithNibName:@"SCTableViewCell" bundle:nil] forCellReuseIdentifier:@"SOUNDCLOUD_CELL"];
  self.musicianTableView.dataSource = self;
  self.musicianTableView.delegate = self;
 // cell = [self.musicianTableView dequeueReusableCellWithIdentifier:@"SCTableViewCell"];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

-(SCTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SOUNDCLOUD_CELL"];
  
  if (!cell) {
    [self.musicianTableView registerNib:[UINib nibWithNibName:@"SCTableViewCell" bundle:nil] forCellReuseIdentifier:@"SOUNDCLOUD_CELL"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"@SOUNDCLOUD_CELL"];
  }
  cell.label.text = [self.items objectAtIndex:indexPath.row];
  cell.imageView.image = [UIImage imageNamed:@"musician.jpg"];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [_audioPlayer play];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [_audioPlayer stop];
  [_audioPlayer setCurrentTime:0];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

#warning mark - needs parameter for viewed musician phone#
- (void)showSMS {
  
  if(![MFMessageComposeViewController canSendText]) {
    UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [warningAlert show];
    return;
  }
#warning mark - wrong recipient
  NSArray *recipient = @[@"2106026818",@"5754188175",@"7753387095"];
  NSString *message = [NSString stringWithFormat:@""];
  
  MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
  messageController.messageComposeDelegate = self;
  [messageController setRecipients:recipient];
  [messageController setBody:message];
  
  [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
  switch (result) {
    case MessageComposeResultCancelled:
      break;
    case MessageComposeResultFailed:
    {
      UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [warningAlert show];
      break;
    }
    case MessageComposeResultSent:
      break;
    default:
      break;
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.label.text = [self.items objectAtIndex:indexPath.row];
}
 */

- (IBAction)textButtonPressed:(id)sender {
  [self showSMS];
}

- (IBAction)emailButtonPressed:(id)sender {
  
}
@end