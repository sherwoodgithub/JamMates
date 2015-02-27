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
#import "QuestionTableViewCell.h"

@interface SearchTracksViewController () <UISearchBarDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *tracks;
@property (strong, nonatomic) Track *track;

@end

@implementation SearchTracksViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.searchBar.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}//view did load


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [[NetworkController sharedNetworkController] searchForTracksWithQuery:searchBar.text withCompletionHandler:^(NSArray *resultArray, NSString *error) {
    self.tracks = resultArray;
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // TrackTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  // track.streamURL = cell.stream_url
  // user.streamURL property  of track[0] is updated

}

@end

