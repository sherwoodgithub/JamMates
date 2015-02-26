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
#import "QuestionTableViewCell.h"

@interface SearchTracksViewController () <UISearchBarDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *tracks;

@end

@implementation SearchTracksViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.searchBar.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}//view did load


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [[NetworkController sharedNetworkController] searchForTracksWithQuery:searchBar.text];
  
//  [[NetworkController sharedNetworkController] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
//    
//    self.questions = results;
//    if (error) {
//      
//      UIAlertView *networkIssueAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//      [networkIssueAlert show];
//    }
//    [self.tableView reloadData];
//  }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tracks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   QuestionTableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL"forIndexPath:indexPath];
 // cell.avatarImageView.image     = nil;
 // Quest *question             = self.questions[indexPath.row];
 // cell.titleTextView.text        = question.title;
  
//  if (!question.image) {
//    
//    [[NetworkController sharedNetworkController] fetchUserImage:question.avatarURL completionHandler:^(UIImage *image) {
//      
//      question.image                 = image;
//      cell.avatarImageView.image     = image;
//    }];
//  } else {
//    
//    cell.avatarImageView.image     = question.image;
//  }//if else
  return cell;
}
@end

