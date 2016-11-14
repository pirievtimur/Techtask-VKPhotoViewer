//
//  PVAlbumsTableViewController.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVAlbumsTableViewController.h"
#import "PVPhotosTableViewController.h"
#import "PVAlbumTableViewCell.h"
#import "PVAlbumModel.h"
#import "UIAlertController+Additions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

// vk api methods, parameters
static NSString *getAlbumsMethod = @"photos.getAlbums";
static NSString *VK_API_NEED_SYSTEM = @"need_system";
static NSString *VK_API_NEED_THUMBS = @"need_covers";

static const CGFloat CELL_HEIGHT = 150;

@interface PVAlbumsTableViewController ()

@property (nonatomic, strong) VKUser *currentUser;
@property (nonatomic, strong) NSMutableArray* albumsData;

@end

@implementation PVAlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
    
    //register nib
    NSString *identifier = NSStringFromClass([PVAlbumTableViewCell class]);
    UINib *cellNib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:identifier];
    
    //set refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshUserAlbumsData) forControlEvents:UIControlEventValueChanged];

    //load data for table
    [self getUserAlbums];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self.navigationController setNavigationBarHidden:false];
}

// MARK: - User's albums data

- (void)getUserAlbums {
    VKRequest *userRequest = [[VKApiUsers new] get];
    [userRequest executeWithResultBlock:^(VKResponse *response) {
        
        MBProgressHUD *activityView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        activityView.mode = MBProgressHUDModeIndeterminate;
        
        self.currentUser = [response.parsedModel firstObject];
        NSDictionary *albumsRequestParameters = @{VK_API_OWNER_ID : self.currentUser.id,  VK_API_NEED_SYSTEM: @"1",  VK_API_NEED_THUMBS: @"1"};
        
        VKRequest *albumsRequest = [VKRequest requestWithMethod:getAlbumsMethod parameters:albumsRequestParameters];
        [albumsRequest executeWithResultBlock:^(VKResponse *response) {
            
            self.albumsData = [self parseResponse:response.json];
            [activityView hide:YES];
            
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            [activityView hide:YES];
            NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
            [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
        }];
    } errorBlock:^(NSError *error) {
        NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
        [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
    }];
}

- (void)refreshUserAlbumsData {
    //additional method to avoid activity view during spinner
    VKRequest *userRequest = [[VKApiUsers new] get];
    [userRequest executeWithResultBlock:^(VKResponse *response) {
        self.currentUser = [response.parsedModel firstObject];
        NSDictionary *albumsRequestParameters = @{VK_API_OWNER_ID : self.currentUser.id,  VK_API_NEED_SYSTEM: @"1",  VK_API_NEED_THUMBS: @"1"};
        
        VKRequest *albumsRequest = [VKRequest requestWithMethod:getAlbumsMethod parameters:albumsRequestParameters];
        [albumsRequest executeWithResultBlock:^(VKResponse *response) {
            self.albumsData = [self parseResponse:response.json];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } errorBlock:^(NSError *error) {
            [self.refreshControl endRefreshing];
            NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
            [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
        }];
    } errorBlock:^(NSError *error) {
        [self.refreshControl endRefreshing];
        NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
        [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
    }];

}

- (NSMutableArray*)parseResponse:(NSDictionary*)responseObject {
    NSMutableArray *array = [NSMutableArray new];
    for (id jsonItem in responseObject[@"items"]) {
        NSError *error = nil;
        
        PVAlbumModel *albumModel = [MTLJSONAdapter modelOfClass:PVAlbumModel.class fromJSONDictionary:jsonItem error:&error];

        if (error) {
#if DEBUG
            NSLog(@"Unable to parse item %@", jsonItem);
#endif
            continue;
        }
        
        [array addObject:albumModel];
    }
    
    return array;
}
    
// MARK: - Logout
    
- (void)logout {
    [VKSdk forceLogout];
    [self.navigationController popViewControllerAnimated:true];
}

// MARK: - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self albumsData] count];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([PVAlbumTableViewCell class]);
    PVAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    PVAlbumModel *dataForCell = [self.albumsData objectAtIndex:indexPath.row];
    [cell updateWithModel:dataForCell];
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PVPhotosTableViewController *photosVC = [PVPhotosTableViewController newInstance];
    PVAlbumModel *dataForCell = [self.albumsData objectAtIndex:indexPath.row];
    photosVC.title = dataForCell.title;
    photosVC.albumId = dataForCell.albumId;
    photosVC.user = self.currentUser;
    [self.navigationController pushViewController:photosVC animated:true];
}
    
// MARK: - Table view delegate
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}
    
@end
