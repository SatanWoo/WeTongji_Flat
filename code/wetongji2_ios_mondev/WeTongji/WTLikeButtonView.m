//
//  WTLikeButtonView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLikeButtonView.h"
#import "LikeableObject+Addition.h"
#import "Object+Addition.h"

@interface WTLikeButtonView ()

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, weak) LikeableObject *object;

@end

@implementation WTLikeButtonView

+ (WTLikeButtonView *)createLikeButtonViewWithObject:(LikeableObject *)object {
    WTLikeButtonView *result = [[WTLikeButtonView alloc] init];
    [result configureLikeButton];
    [result configureViewWithObject:object];
    return result;
}

- (void)setLikeCount:(NSUInteger)likeCount {
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCount];
}

- (NSUInteger)getLikeCount {
    return self.likeCountLabel.text.integerValue;
}

- (void)configureViewWithObject:(LikeableObject *)object {
    self.likeButton.selected = object.likedByCurrentUser;
    [self setLikeCount:object.likeCount.integerValue];
    self.object = object;
}

- (void)configureLikeButton {
    UIButton *likeButton = [[UIButton alloc] init];
    UIImage *likeNormalImage = [UIImage imageNamed:@"WTLikeNormalButton"];
    UIImage *likeSelectImage = [UIImage imageNamed:@"WTLikeSelectButton"];
    [likeButton setBackgroundImage:likeNormalImage forState:UIControlStateNormal];
    [likeButton setBackgroundImage:likeSelectImage forState:UIControlStateSelected];
    [likeButton resetSize:likeNormalImage.size];
    likeButton.adjustsImageWhenHighlighted = NO;
    
    self.likeButton = likeButton;
    self.frame = likeButton.frame;
    
    UIImageView *likeFlagBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTLikeButtonFlagBg"]];
    
    UILabel *likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, likeButton.frame.size.width, 20)];
    likeCountLabel.textAlignment = NSTextAlignmentCenter;
    likeCountLabel.font = [UIFont boldSystemFontOfSize:10];
    likeCountLabel.backgroundColor = [UIColor clearColor];
    likeCountLabel.textColor = [UIColor colorWithRed:150 / 255.0f green:150 / 255.0f blue:150 / 255.0f alpha:1];
    likeCountLabel.shadowColor = [UIColor whiteColor];
    likeCountLabel.shadowOffset = CGSizeMake(0, 1);
    likeCountLabel.text = @"53";
    
    self.likeCountLabel = likeCountLabel;

    [likeButton resetOriginY:1];
    [likeFlagBg resetOriginY:0];
    [likeFlagBg resetCenterX:likeButton.frame.size.width / 2];
    [likeCountLabel resetOriginY:likeFlagBg.frame.size.height - 38];
    [self addSubview:likeFlagBg];
    [self addSubview:likeButton];
    [self addSubview:likeCountLabel];
    
    [self.likeButton addTarget:self action:@selector(didClickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickLikeButton:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Set object liked:%d succeeded", sender.selected);
        self.object.likeCount = @(self.object.likeCount.integerValue + (sender.selected ? 1 : (-1)));
        [self setLikeCount:self.object.likeCount.integerValue];
        self.object.likedByCurrentUser = sender.selected;
        self.userInteractionEnabled = YES;
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Set object liked:%d, reason:%@", sender.selected, error.localizedDescription);
        sender.selected = !sender.selected;
        
        [WTErrorHandler handleError:error];
        self.userInteractionEnabled = YES;
    }];
    [request setObjectliked:sender.selected model:[self.object getObjectModelType] modelID:self.object.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
