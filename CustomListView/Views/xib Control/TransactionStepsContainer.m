//
//  TransactionStepsContainer.m
//  WalletBalance
//
//  Created by DigitalWallet on 2/15/16.
//  Copyright © 2016 Kartuku. All rights reserved.
//

#import "TransactionStepsContainer.h"
#import "CellConfiguration.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@implementation TransactionStepsContainer{
    NSMutableArray *cellDescriptors;
    NSMutableArray *visibleRowPerSection;
    NSMutableArray *cellConfigurations;
    NSMutableArray *stackOpenedCell;
    NSMutableDictionary *levelOfCell;
    NSMutableArray *contentOfLevel;
    int contentPadding;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        cellConfigurations = [[NSMutableArray alloc] init];
        cellDescriptors = [[NSMutableArray alloc] init];
        visibleRowPerSection = [[NSMutableArray alloc] init];
        stackOpenedCell = [[NSMutableArray alloc] init];
        levelOfCell = [[NSMutableDictionary alloc] init];
        contentOfLevel = [[NSMutableArray alloc] init];
        contentPadding = 2;
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"TransactionStepsContainer" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.view.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.view];
    
    [self configureTableView];
    [self loadCellDescriptors];
}

- (void) configureTableView{
    [self stepsContainer].delegate = self;
    [self stepsContainer].dataSource = self;
    [self stepsContainer].tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"idCellNormal"];
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"ParentCell" bundle:nil] forCellReuseIdentifier:@"idCellParent"];
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"SubCell" bundle:nil]
        forCellReuseIdentifier:@"idCellSub"];
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"ContentCell" bundle:nil] forCellReuseIdentifier:@"idCellContent"];
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"Separator" bundle:nil] forCellReuseIdentifier:@"idCellSeparator"];
    [[self stepsContainer] registerNib:[UINib nibWithNibName:@"CombinationCell" bundle:nil] forCellReuseIdentifier:@"idCellCombination"];
    
}

- (void) loadCellDescriptors{
    if([[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"];
        cellDescriptors = [NSMutableArray arrayWithContentsOfFile:path];
        [self modelingPlistFile];
        [self.stepsContainer reloadData];
    }
}

- (void) modelingPlistFile{
    [cellConfigurations removeAllObjects];
    NSArray *section = [[NSArray alloc] init];
    for (section in cellDescriptors){
        for (int i = 0; i < [section count] ; i++) {
            CellConfiguration *cellConfigurationDetail = [[CellConfiguration alloc] init];
            [contentOfLevel removeAllObjects];
            
            if(section[i][@"cellIdentifier"] != nil){
                cellConfigurationDetail.cellId = section[i][@"cellIdentifier"];
            }
            if(section[i][@"cellParent"] != nil){
                cellConfigurationDetail.parentRow = [section[i][@"cellParent"] integerValue];
            }
            if(section[i][@"level"] != nil){
                cellConfigurationDetail.level = [section[i][@"level"] integerValue];
            }
            if(section[i][@"clickable"] != nil){
                cellConfigurationDetail.clickable = [section[i][@"clickable"] boolValue];
            }
            if(section[i][@"BottomShadow"] != nil){
                cellConfigurationDetail.bottomShadow = [section[i][@"BottomShadow"] boolValue];
            }
            if(section[i][@"TopShadow"] != nil){
                cellConfigurationDetail.topShadow = [section[i][@"TopShadow"] boolValue];
            }
            if(section[i][@"withoutSeparator"] != nil){
                cellConfigurationDetail.withoutSeparator = [section[i][@"withoutSeparator"] boolValue];
            }
            [cellConfigurations addObject:cellConfigurationDetail];
        }
    }
}

- (NSString *) getCellIdForIndexPath:(NSIndexPath *)indexPath{
    CellConfiguration *cellConfigurationDetail = cellConfigurations[indexPath.row];
    
    return cellConfigurationDetail.cellId;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cellConfigurations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIdForIndexPath:indexPath] forIndexPath:indexPath];
    
    CellConfiguration *selectedCellInfo = cellConfigurations[indexPath.row];
    float realCellHeight = [self getCellHeightById:selectedCellInfo.cellId];
    
    UIView *customContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    customContainer.tag = 1001;
    
    [self deleteSubViewByTag:1001 view:cell];
    
    //Prepare uiview
    UIView *halfRoundBottom = [self roundView:CGRectMake(0, realCellHeight/2, cell.frame.size.width, realCellHeight/2) radius:0.8 shadowOpacity:0.0 backgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] shadowColor:[UIColor lightGrayColor]];
    UIView *radiusRoundFullTop = [self roundView:CGRectMake(0, 0, cell.frame.size.width, realCellHeight) radius:8.0 shadowOpacity:0.0 backgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] shadowColor:[UIColor lightGrayColor]];
    UIView *radiusRoundEffectTopOnBottom = [self roundView:CGRectMake(0, realCellHeight, cell.frame.size.width, realCellHeight) radius:8.0 shadowOpacity:0.01 backgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] shadowColor:[UIColor lightGrayColor]];
    UIView *radiusRoundOverlapBottom = [self roundView:CGRectMake(0, -11, cell.frame.size.width, 17) radius:8.0 shadowOpacity:0.0 backgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] shadowColor:[UIColor lightGrayColor]];
    UIView *radiusRoundOverlapTop = [self roundView:CGRectMake(0, 0, cell.frame.size.width, 17) radius:8.0 shadowOpacity:0.001 backgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] shadowColor:[UIColor lightGrayColor]];
    UIView *separatorLine = [self roundView:CGRectMake(0, realCellHeight-1, cell.frame.size.width, 1) radius:0.0 shadowOpacity:0.0 backgroundColor:[UIColor lightGrayColor] shadowColor:[UIColor lightGrayColor]];
    
    
    radiusRoundEffectTopOnBottom.layer.shadowOffset = CGSizeMake(0, 5);
    radiusRoundOverlapTop.layer.shadowOffset = CGSizeMake(0, 3);
    if([selectedCellInfo.cellId isEqualToString:@"idCellParent"]){
        cell.contentView.layer.backgroundColor = [UIColor clearColor].CGColor;
        cell.layer.backgroundColor = [UIColor clearColor].CGColor;
        radiusRoundOverlapBottom.layer.shadowOpacity = 0.0;
        radiusRoundFullTop.layer.shadowOffset = CGSizeMake(0, 3);
        
        if(selectedCellInfo.topShadow){
            [customContainer addSubview:radiusRoundOverlapBottom];
            [customContainer addSubview:radiusRoundOverlapTop];
        }
        
        [customContainer addSubview:radiusRoundFullTop];
        
        if((selectedCellInfo.isExpand && selectedCellInfo.topShadow) || selectedCellInfo.bottomShadow)
            [customContainer addSubview:halfRoundBottom];
        
        if(selectedCellInfo.bottomShadow && !selectedCellInfo.isExpand)
            [customContainer addSubview:radiusRoundEffectTopOnBottom];
        
//        [cell addSubview:customContainer];
        [cell insertSubview:customContainer atIndex:0];
    }else if([selectedCellInfo.cellId isEqualToString:@"idCellSub"] || [selectedCellInfo.cellId isEqualToString:@"idCellContent"]){
        radiusRoundEffectTopOnBottom.layer.shadowOffset = CGSizeMake(0, 5);
        radiusRoundOverlapBottom.layer.shadowOpacity = 0.2;
        if(selectedCellInfo.topShadow){
            [customContainer addSubview:radiusRoundOverlapBottom];
        }
        if(selectedCellInfo.bottomShadow && !selectedCellInfo.isExpand && !selectedCellInfo.withoutSeparator){
            [customContainer addSubview:radiusRoundEffectTopOnBottom];
        }
        if(!selectedCellInfo.bottomShadow && !selectedCellInfo.isExpand && !selectedCellInfo.withoutSeparator)
            [customContainer addSubview:separatorLine];
        
        [cell addSubview:customContainer];
    }
    
    if(!selectedCellInfo.clickable){
        cell.userInteractionEnabled = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *) roundView:(CGRect) viewFrame radius:(float) radius shadowOpacity:(float) shadowOpacity backgroundColor:(UIColor *)color shadowColor:(UIColor *)shadowColor{
    UIView *createView = [[UIView alloc] initWithFrame:viewFrame];
    createView.layer.cornerRadius = radius;
    if(shadowOpacity>0.0){
        createView.layer.shadowColor = shadowColor.CGColor;
        createView.layer.shadowRadius = radius;
        createView.layer.shadowOpacity = shadow;
    }
    createView.backgroundColor = color;
    
    return createView;
}

- (UIView *) deleteSubViewByTag:(int) tag view:(UIView *)view{
    UIView *removeView = [[UIView alloc] init];
    while((removeView = [view viewWithTag:tag]) != nil) {
        [removeView removeFromSuperview];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightByIndexPath:indexPath];
}

- (float) cellHeightByIndexPath : (NSIndexPath*) indexPath{
    CellConfiguration *currentCell = cellConfigurations[indexPath.row];
    CellConfiguration *parentCell = nil;
    if(currentCell.parentRow != -1){
        parentCell = cellConfigurations[currentCell.parentRow];
    }
    
    if(currentCell!=nil && (parentCell == nil || parentCell.isExpand == YES)){
        if(!currentCell.topShadow)
            return [self getCellHeightById:currentCell.cellId];
        else
            return [self getCellHeightById:currentCell.cellId];
    }
    return 0.0f;
}

- (float) getCellHeightById: (NSString *)cellId{
    
    if([cellId isEqualToString:@"idCellParent"] || [cellId isEqualToString:@"idCellContent"])
        return 100.0f;
    else
    if([cellId isEqualToString:@"idCellSub"])
        return 45.0f;
    else
    if([cellId isEqualToString:@"idCellCombination"])
        return 160.0f;
    else
    if([cellId isEqualToString:@"idCellSeparator"])
        return 44.0f;
    else
        return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CATransaction begin];
    if(((CellConfiguration *)cellConfigurations[indexPath.row]).isExpand){
        [self closeAnotherCellSameLevelAndMore:((CellConfiguration *)cellConfigurations[indexPath.row]).level];
        ((CellConfiguration *)cellConfigurations[indexPath.row]).isExpand = NO;
    }else{
        [self closeAnotherCellSameLevelAndMore:((CellConfiguration *)cellConfigurations[indexPath.row]).level];
        ((CellConfiguration *)cellConfigurations[indexPath.row]).isExpand = YES;
    }
    
    if(![((CellConfiguration *)cellConfigurations[indexPath.row]).cellId isEqualToString:@"idCellCombination"])
        [self.stepsContainer reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [CATransaction setCompletionBlock:^{
    if([stackOpenedCell count] >= ((CellConfiguration *)cellConfigurations[indexPath.row]).level &&
       ![((CellConfiguration *)cellConfigurations[indexPath.row]).cellId isEqualToString:@"idCellCombination"]){
        
        int stackSize = [stackOpenedCell count];
        for (int i = ((CellConfiguration *)cellConfigurations[indexPath.row]).level-1; i < stackSize; i++) {
            if((NSIndexPath *)stackOpenedCell[((CellConfiguration *)cellConfigurations[indexPath.row]).level-1] != indexPath)
            [self.stepsContainer reloadRowsAtIndexPaths:@[(NSIndexPath *)stackOpenedCell[((CellConfiguration *)cellConfigurations[indexPath.row]).level-1]] withRowAnimation:UITableViewRowAnimationFade];
            [stackOpenedCell removeObjectAtIndex:((CellConfiguration *)cellConfigurations[indexPath.row]).level-1];
        }
        
    }
        [stackOpenedCell addObject:indexPath];
    }];
    [self.stepsContainer scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [CATransaction commit];
}

- (void) closeAnotherCellSameLevelAndMore:(int) cellLevel{
    for (int i=0; i<[cellConfigurations count]; i++) {
        if(((CellConfiguration *)cellConfigurations[i]).level >= cellLevel)
            ((CellConfiguration *)cellConfigurations[i]).isExpand = NO;
    }
}
@end
