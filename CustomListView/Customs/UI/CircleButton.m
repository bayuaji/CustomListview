//
//  CircleButton.m
//  WalletBalance
//
//  Created by DigitalWallet on 2/25/16.
//  Copyright © 2016 Kartuku. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    dummyView.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:170.0/255.0 blue:9.0/255.0 alpha:1];
    dummyView.layer.cornerRadius = self.frame.size.width/2;
    [self insertSubview:dummyView atIndex:0];
}
@end
