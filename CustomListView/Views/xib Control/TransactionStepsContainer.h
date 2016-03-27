//
//  TransactionStepsContainer.h
//  WalletBalance
//
//  Created by DigitalWallet on 2/15/16.
//  Copyright © 2016 Kartuku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "TPKeyboardAvoidingTableView.h"

@interface TransactionStepsContainer : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UITableView *stepsContainer;

@end
