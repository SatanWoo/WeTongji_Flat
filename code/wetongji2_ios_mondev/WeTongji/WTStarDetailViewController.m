//
//  WTStarDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarDetailViewController.h"
#import "Star+Addition.h"
#import "WTStarHeaderView.h"
#import "WTStarDetailDescriptionView.h"
#import "WTStarImageRollView.h"
#import "WTDetailImageViewController.h"

@interface WTStarDetailViewController () <WTDetailImageViewControllerDelegate>

@property (nonatomic, strong) Star *star;
@property (nonatomic, weak) WTStarHeaderView *headerView;
@property (nonatomic, weak) WTStarDetailDescriptionView *detailView;
@property (nonatomic, weak) WTStarImageRollView *imageRollView;

@end

@implementation WTStarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

+ (WTStarDetailViewController *)createDetailViewControllerWithStar:(Star *)star
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTStarDetailViewController *result = [[WTStarDetailViewController alloc] init];
    
    result.star = star;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureHeaderView];
    [self configureImageRollView];
    [self configureDetailDescriptionView];
    [self configureScrollView];
}

- (void)configureHeaderView {
    WTStarHeaderView *headerView = [WTStarHeaderView createHeaderViewWithStar:self.star];
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;    
}

- (void)configureImageRollView {
    
    WTStarImageRollView *imageRollView = [WTStarImageRollView createImageRollViewWithImageURLStringArray:self.star.imageURLStringArray imageDescriptionArray:self.star.imageDescriptionArray];
    [imageRollView resetOriginY:self.headerView.frame.size.height];
    [self.scrollView insertSubview:imageRollView belowSubview:self.headerView];
    self.imageRollView = imageRollView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagImageRollView:)];
    [self.imageRollView.scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)configureDetailDescriptionView {
    WTStarDetailDescriptionView *detailView = [WTStarDetailDescriptionView createDetailDescriptionViewWithStar:self.star];
    [detailView resetOriginY:self.imageRollView.frame.size.height + self.imageRollView.frame.origin.y];
    [self.scrollView addSubview:detailView];
    self.detailView = detailView;
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.detailView.frame.origin.y + self.detailView.frame.size.height);
}

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.star;
}

- (NSArray *)imageArrayToShare {
    NSMutableArray *result = [NSMutableArray array];
    UIImage *currentImage = self.imageRollView.currentItemView.imageView.image;
    if (currentImage)
        [result addObject:currentImage];
    for (int i = 0; i < self.imageRollView.pageControl.numberOfPages; i++) {
        WTStarImageRollItemView *itemView = [self.imageRollView itemViewAtIndex:i];
        UIImage *image = itemView.imageView.image;
        if (image != currentImage)
            [result addObject:image];
    }
    return result;
}

- (NSString *)textToShare {
    return [NSString stringWithFormat:@"济人第%@期——%@:“%@”\n\n%@\n\n%@", self.star.volume, self.star.name, self.star.motto, self.star.jobTitle, self.star.content];
}

#pragma mark - Handle gesture methods

- (void)didTagImageRollView:(UITapGestureRecognizer *)gesture {
    WTStarImageRollItemView *currentItemView = [self.imageRollView currentItemView];
    UIImageView *currentImageView = currentItemView.imageView;
    CGRect imageViewFrame = [self.view convertRect:currentImageView.frame fromView:currentImageView];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLArray:self.star.imageURLStringArray
                                                          currentPage:self.imageRollView.pageControl.currentPage
                                                        fromImageView:currentImageView
                                                             fromRect:imageViewFrame
                                                             delegate:self];
}

#pragma mark - WTDetailImageViewControllerDelegate

- (void)detailImageViewControllerDidDismiss:(NSUInteger)currentPage {
    self.imageRollView.scrollView.contentOffset = CGPointMake(self.imageRollView.scrollView.frame.size.width * currentPage, 0);
    self.imageRollView.pageControl.currentPage = currentPage;
    [self.imageRollView reloadItemImages];
}

@end
