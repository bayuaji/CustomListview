//
//  CellConfiguration.h
//  WalletBalance
//
//  Created by DigitalWallet on 2/15/16.
//  Copyright © 2016 Kartuku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellConfiguration : NSObject

@property (nonatomic,retain) NSString* cellId;
@property (nonatomic,retain) NSString* cellPrimaryTitle;
@property (nonatomic,retain) NSString* cellSecondaryTitle;
@property (nonatomic) BOOL clickable;
@property (nonatomic) BOOL isExpand;
@property (nonatomic) BOOL topShadow;
@property (nonatomic) BOOL bottomShadow;
@property (nonatomic) BOOL withoutSeparator;
@property (nonatomic) int level;
@property (nonatomic) int parentRow;

@end
