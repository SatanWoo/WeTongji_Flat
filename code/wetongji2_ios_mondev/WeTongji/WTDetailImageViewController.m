//
//  WTImageViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailImageViewController.h"
#import "UIApplication+WTAddition.h"
#import "WTDetailImageItemView.h"
#import "UIImageView+ContentScale.m"

@interface WTDetailImageViewController () <WTDetailImageItemViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) NSArray *imageURLArray;
@property (nonatomic, assign) NSUInteger initPage;

@property (nonatomic, assign) CGRect showFromRect;
@property (nonatomic, weak) UIImageView *showFromImageView;

@end

@implementation WTDetailImageViewController

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
}

+ (void)showDetailImageViewWithImageURLString:(NSString *)imageURLString
                                fromImageView:(UIImageView *)fromImageView
                                     fromRect:(CGRect)fromRect
                                     delegate:(id<WTDetailImageViewControllerDelegate>)delegate {
    if (!imageURLString)
        return;
    [WTDetailImageViewController showDetailImageViewWithImageURLArray:@[imageURLString]
                                                          currentPage:0
                                                        fromImageView:fromImageView
                                                             fromRect:fromRect
                                                             delegate:delegate];
}

+ (void)showDetailImageViewWithImageURLArray:(NSArray *)imageURLArray
                                 currentPage:(NSUInteger)currentPage
                               fromImageView:(UIImageView *)fromImageView
                                    fromRect:(CGRect)fromRect
                                    delegate:(id<WTDetailImageViewControllerDelegate>)delegate {
    WTDetailImageViewController *vc = [WTDetailImageViewController createDetailImageViewControllerWithImageURLArray:imageURLArray];
    vc.initPage = currentPage;
    vc.showFromImageView = fromImageView;
    vc.showFromRect = fromRect;
    vc.delegate = delegate;
    
    [vc configureView];
    
    [vc show];
}

+ (WTDetailImageViewController *)createDetailImageViewControllerWithImageURLArray:(NSArray *)imageURLArray {
    WTDetailImageViewController *result = [[WTDetailImageViewController alloc] init];
    result.itemViewArray = [NSMutableArray arrayWithCapacity:4];
    result.imageURLArray = imageURLArray;
    return result;
}

#pragma mark - UI methods

- (void)show {
    [UIApplication presentKeyWindowViewController:self animated:NO];
    [self fadeInViewAnimation];
    if (self.showFromImageView.image)
        [self showTransitionImageViewAnimation];
}

- (void)showTransitionImageViewAnimation {
    WTDetailImageItemView *currentItemView = self.itemViewArray[self.initPage];
    currentItemView.hidden = YES;
    
    UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:self.showFromImageView.image];
    UIImage *transitionImage = self.showFromImageView.image;
    
    transitionImageView.frame = self.view.frame;
    transitionImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize targetSize = CGSizeMake(transitionImage.size.width * transitionImageView.contentScaleFactor, transitionImage.size.height * transitionImageView.contentScaleFactor);
    
    transitionImageView.frame = self.showFromRect;
    transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
    transitionImageView.clipsToBounds = YES;
    
    [self.view addSubview:transitionImageView];
    self.showFromImageView.hidden = YES;

    [UIView animateWithDuration:0.3f animations:^{
        transitionImageView.bounds = CGRectMake(0, 0, targetSize.width, targetSize.height);
        transitionImageView.center = self.view.center;
    } completion:^(BOOL finished) {
        [transitionImageView removeFromSuperview];
        currentItemView.hidden = NO;
    }];
}

- (void)fadeInViewAnimation {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.bgView.alpha = 0;
    self.pageControl.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.bgView.alpha = 1.0f;
        self.pageControl.alpha = 1.0f;
    }];
}

- (void)dismissTransitionImageViewAnimation {
    WTDetailImageItemView *currentItemView = self.itemViewArray[self.pageControl.currentPage];
    UIImageView *currentImageView = currentItemView.imageView;
    currentItemView.hidden = YES;
    
    UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:currentImageView.image];
    
    transitionImageView.frame = currentImageView.frame;
    [transitionImageView resetOrigin:CGPointMake(transitionImageView.frame.origin.x - currentItemView.scrollView.contentOffset.x, transitionImageView.frame.origin.y - currentItemView.scrollView.contentOffset.y)];
    transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
    transitionImageView.clipsToBounds = YES;
    
    [self.view addSubview:transitionImageView];
    
    [UIView animateWithDuration:0.3f animations:^{
        transitionImageView.bounds = CGRectMake(0, 0, self.showFromRect.size.width, self.showFromRect.size.height);
        transitionImageView.center = CGPointMake(self.showFromRect.size.width / 2 + self.showFromRect.origin.x, self.showFromRect.size.height / 2 + self.showFromRect.origin.y);
    } completion:^(BOOL finished) {
        [transitionImageView removeFromSuperview];
        self.showFromImageView.hidden = NO;
    }];
}

- (void)dismissView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3f animations:^{
        self.bgView.alpha = 0;
        self.pageControl.alpha = 0;
    } completion:^(BOOL finished) {
        [self.delegate detailImageViewControllerDidDismiss:self.pageControl.currentPage];
        [UIApplication dismissKeyWindowViewControllerAnimated:NO];
    }];
    
    [self dismissTransitionImageViewAnimation];
}

#define IMAGE_ITEM_VIEW_SPACING 20.0f

- (void)configureView {
    [self.view resetSize:[UIScreen mainScreen].bounds.size];
    for (NSString *imageURLString in self.imageURLArray) {
        WTDetailImageItemView *itemView = [WTDetailImageItemView createDetailItemViewWithImageURLString:imageURLString
                                                                                               delegate:self];
        [itemView resetOriginX:self.scrollView.frame.size.width * self.itemViewArray.count];
        [self.scrollView addSubview:itemView];
                
        [self.itemViewArray addObject:itemView];
    }
    self.pageControl.numberOfPages = self.imageURLArray.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.imageURLArray.count, self.scrollView.frame.size.height);
    
    self.pageControl.currentPage = self.initPage;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.initPage, 0);
}

- (void)updatePageControl {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if (self.pageControl.currentPage != currentPage) {
        WTDetailImageItemView *itemView = self.itemViewArray[self.pageControl.currentPage];
        itemView.scrollView.zoomScale = 1.0f;
        
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark - WTDetailImageItemViewDelegate

- (void)userTappedDetailImageItemView:(WTDetailImageItemView *)itemView {
    [self dismissView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self updatePageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl];
}

@end