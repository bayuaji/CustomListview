//
//  BalanceCustom.m
//  WalletBalance
//
//  Created by DigitalWallet on 2/15/16.
//  Copyright © 2016 Kartuku. All rights reserved.
//

#import "BalanceCustom.h"

@implementation BalanceCustom

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
