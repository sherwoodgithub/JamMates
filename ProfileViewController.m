//
//  ProfileViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "ProfileViewController.h"
#import "SCTableViewCell.h"
#import "SearchTracksViewController.h"
#import "User.h"

#import <AVFoundation/AVFoundation.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSArray *tracksArray;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //[self addMyButton];
  User *user = [User sharedUser];

  //Audio Track
  NSString *path = [NSString stringWithFormat:@"%@/200.mp3",[[NSBundle mainBundle] resourcePath]];
  NSURL *soundURL = [NSURL fileURLWithPath:path];
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  
  //Tableview Nib
  
  _items = @[@"1",@"2",@"3"];
  
  [self.profileTableView registerNib:[UINib nibWithNibName:@"SCTableViewCell" bundle:nil] forCellReuseIdentifier:@"SOUNDCLOUD_CELL"];
  self.profileTableView.dataSource = self;
  self.profileTableView.delegate = self;
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
    [self.profileTableView registerNib:[UINib nibWithNibName:@"SCTableViewCell" bundle:nil] forCellReuseIdentifier:@"SOUNDCLOUD_CELL"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"@SOUNDCLOUD_CELL"];
  }
  cell.label.text = [self.items objectAtIndex:indexPath.row];
  cell.imageView.image = [UIImage imageNamed:@"musician.jpg"];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // if edit mode:
    // go to searchViewController
    // update cell with user track
  
  
  NSLog(@"%ld",(long)indexPath.row);
  
  // else ( play mode ) :
  [_audioPlayer play];
  
  // for giving us a checkmark upon click
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [_audioPlayer stop];
  [_audioPlayer setCurrentTime:0];
  
  // for giving us a disclosureindicator back
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
}
- (IBAction)firstCellButtonPressed:(id)sender {
  
}
- (IBAction)secondCellButtonPressed:(id)sender {
  
}
- (IBAction)thirdCellButtonPressed:(id)sender {
  
}

- (IBAction)editButtonPressed:(id)sender {
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"SEARCH_TRACKS"]) {
//    SearchTracksViewController *destinationVC = segue.destinationViewController;
//    destinationVC.trackTitle =
//  }
//}

/*
 - (void)addMyButton{    // Method for creating button, with background image and other properties
 
 UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 playButton.frame = CGRectMake(210.0, 80.0, 100.0, 30.0);
 [playButton setTitle:@"Play" forState:UIControlStateNormal];
 playButton.backgroundColor = [UIColor blueColor];
 [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
 UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
 UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
 [playButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
 UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
 UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
 [playButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
 [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:playButton];
 }
 */
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
/*
 -(void)tableView:(UITableView *)tableView willDisplayCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 cell.label.text = [self.items objectAtIndex:indexPath.row];
 }
 */
@end
