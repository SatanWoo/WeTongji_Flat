//
//  WEBannerItemView.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-11.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEBannerItemView.h"
#import "Activity+Addition.h"
#import "News+Addition.h"
#import "Advertisement+Addition.h"
#import "NSString+WTAddition.h"
#import "Organization+Addition.h"
#import "UIImageView+AsyncLoading.h"

#define kWEBannerItemViewNibName @"WEBannerItemView"

@implementation WEBannerItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (WEBannerItemView *)createBannerItemView
{
    NSArray *result = [[NSBundle mainBundle] loadNibNamed:kWEBannerItemViewNibName owner:self options:nil];
    return [result lastObject];
}

- (void)configureViewWithModelObject:(Object *)object {
    if ([object isKindOfClass:[Activity class]]) {
        Activity *activity = (Activity *)object;
        self.imageURLString = activity.image;
        self.title.text = activity.what;
        self.org.text = activity.author.name;
    } else if ([object isKindOfClass:[News class]]) {
        News *news = (News *)object;
        NSArray *imageArray = news.imageArray;
        if (imageArray) {
            self.imageURLString = imageArray[0];
        }
        self.title.text = news.title;
        self.org.text = news.author.name;
    } else if ([object isKindOfClass:[Advertisement class]]) {
        Advertisement *ad = (Advertisement *)object;
        self.imageURLString = ad.image;
        self.title.text = ad.title;
        self.org.text = ad.publisher;
        //self.containerView.backgroundColor = [ad.bgColorHex converHexStringToColorWithAlpha:0.6f];
    }
    
    CGPoint titleLabelCenter = self.title.center;
    [self.title sizeToFit];
    self.title.center = titleLabelCenter;
    [self.org resetOriginY:self.title.frame.size.height + self.title.frame.origin.y];
    
//    self.org = self.org.frame.origin.y;
//    self.title = self.title.frame.origin.y;
    
    [self.imageView loadImageWithImageURLString:self.imageURLString];
}


@end
