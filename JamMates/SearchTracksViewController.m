//
//  SearchTracksViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//
#import "SearchTracksViewController.h"
#import "NetworkController.h"
#import "User.h"
#import "Track.h"
#import "TrackTableViewCell.h"
#import <AVFoundation/AVFoundation.h>


@interface SearchTracksViewController () <UISearchBarDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *tracks;
@property (strong, nonatomic) Track *track;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation SearchTracksViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.searchBar.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [[NetworkController sharedNetworkController] searchForTracksWithQuery:searchBar.text withCompletionHandler:^(NSArray *resultArray, NSString *error) {
    self.tracks = resultArray;
    NSLog(@"%@",self.tracks);
    if (error) {
      
      UIAlertView *networkIssueAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
      [networkIssueAlert show];
    }
    [self.tableView reloadData];
  }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tracks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL"forIndexPath:indexPath];
  
  Track *track = self.tracks[indexPath.row];
  cell.titleText.text = track.title;
  return cell;
  
//  TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL"forIndexPath:indexPath];
//  User *user = [User sharedUser];
//  
//  user.track1 =
//  
//  Track *track = self.tracks[indexPath.row];
//  cell.titleText.text = track.title;
//  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
  self.track = [self.tracks objectAtIndex:indexPath.row];
    NSString *streamingString = [NSString stringWithFormat:@"%@.json?client_id=0c179b66c4fe77ec437daa893f8e564a", self.track.stream_url];
    NSURL *streamingURL = [NSURL URLWithString:streamingString];
  
//  NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    _audioPlayer = [AVPlayer playerWithURL:streamingURL];
    [_audioPlayer play];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [_audioPlayer stop];
  [_audioPlayer setCurrentTime:0];

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end

