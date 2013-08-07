//
//  WTNewsDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsDetailViewController.h"
#import "News+Addition.h"
#import "WTLikeButtonView.h"
#import "WTNewsBriefIntroductionView.h"
#import "OHAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "WTNewsImageRollView.h"
#import "WTDetailImageViewController.h"
#import "WTOrganizationDetailViewController.h"

@interface WTNewsDetailViewController () <WTDetailImageViewControllerDelegate>

@property (nonatomic, strong) WTNewsBriefIntroductionView *briefIntroductionView;
@property (nonatomic, strong) News *news;
@property (nonatomic, strong) WTNewsImageRollView *imageRollView;

@end

@implementation WTNewsDetailViewController

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

+ (WTNewsDetailViewController *)createDetailViewControllerWithNews:(News *)news
                                                 backBarButtonText:(NSString *)backBarButtonText {
    WTNewsDetailViewController *result = [[WTNewsDetailViewController alloc] init];
    result.news = news;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - UI methods

- (void)configureUI {
    [self configureBriefIntroductionView];
    [self configureDetailView];
    [self configureScrollView];
}

- (void)configureScrollView {
    self.scrollView.alwaysBounceVertical = YES;

    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.contentLabelContainerView.frame.origin.y + self.contentLabelContainerView.frame.size.height);
}

- (void)configureBriefIntroductionView {
    self.briefIntroductionView = [WTNewsBriefIntroductionView createNewsBriefIntroductionViewWithNews:self.news];
    [self.scrollView addSubview:self.briefIntroductionView];
    [self.view sendSubviewToBack:self.briefIntroductionView];
}

- (void)configureDetailView {
    [self configureImageRollView];
    [self configureContentLabel];
    [self configureContentLabelContainerView];
}

- (void)configureImageRollView {
    if (self.news.imageArray) {
        self.imageRollView = [WTNewsImageRollView createImageRollViewWithImageURLStringArray:self.news.imageArray];
        [self.imageRollView resetOriginY:0];
        self.imageRollView.autoresizingMask = UIViewAutoresizingNone;
        [self.contentLabelContainerView addSubview:self.imageRollView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTagImageRollView:)];
        [self.imageRollView.scrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

#define CONTENT_LABEL_BOTTOM_PADDING    20.0f

- (void)configureContentLabelContainerView {
    [self.contentLabelContainerView resetOriginY:self.briefIntroductionView.frame.size.height + self.briefIntroductionView.frame.origin.y];
    
    self.contentLabelContainerView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f].CGColor;
    self.contentLabelContainerView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.contentLabelContainerView.layer.shadowOpacity = 0.25f;
    self.contentLabelContainerView.layer.shadowRadius = 0;
    
    [self.contentLabelContainerView resetHeight:self.contentLabel.frame.size.height + self.contentLabel.frame.origin.y + CONTENT_LABEL_BOTTOM_PADDING];
}

#define CONTENT_LABEL_LINE_SPACING  8.0f

- (void)configureContentLabel {
    NSMutableAttributedString *contentAttributedString = [NSMutableAttributedString attributedStringWithString:self.news.content];
    
    [contentAttributedString setAttributes:[self.contentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, contentAttributedString.length)];
    
    [contentAttributedString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    self.contentLabel.attributedText = contentAttributedString;
    
    CGFloat contentLabelHeight = [contentAttributedString sizeConstrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 200000.0f)].height;
    
    [self.contentLabel resetHeight:contentLabelHeight];
    [self.contentLabel resetOriginY:self.imageRollView ? self.imageRollView.frame.size.height : 15.0f];
    
    self.contentLabel.automaticallyAddLinksForType = NSTextCheckingTypeLink;
}

#pragma mark - Actions

- (void)didClickOrganizerButton:(UIButton *)sender {
    WTOrganizationDetailViewController *vc = [WTOrganizationDetailViewController createDetailViewControllerWithOrganization:self.news.author backBarButtonText:self.news.title];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Handle gesture methods

- (void)didTagImageRollView:(UITapGestureRecognizer *)gesture {
    WTNewsImageRollItemView *currentItemView = [self.imageRollView currentItemView];
    UIImageView *currentImageView = currentItemView.imageView;
    CGRect imageViewFrame = [self.view convertRect:currentImageView.frame fromView:currentImageView.superview];
    imageViewFrame.origin.y += 64.0f;
    
    [WTDetailImageViewController showDetailImageViewWithImageURLArray:self.news.imageArray
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

#pragma mark - Methods to overwrite

- (LikeableObject *)targetObject {
    return self.news;
}

- (NSArray *)imageArrayToShare {
    NSMutableArray *result = [NSMutableArray array];
    UIImage *currentImage = self.imageRollView.currentItemView.imageView.image;
    if (currentImage)
        [result addObject:currentImage];
    for (int i = 0; i < self.imageRollView.pageControl.numberOfPages; i++) {
        WTNewsImageRollItemView *itemView = [self.imageRollView itemViewAtIndex:i];
        UIImage *image = itemView.imageView.image;
        if (image != currentImage)
            [result addObject:image];
    }
    return result;
}

- (NSString *)textToShare {
    return [NSString stringWithFormat:@"%@\n\n%@\n\n%@", self.news.title, self.news.yearMonthDayTimePublishTimeString, self.news.content];
}

@end
