//
//  LevelViewController.m
//  RedScarf
//
//  Created by zhangb on 15/11/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "LevelViewController.h"
#import "RSAccountModel.h"
#import "RSHeadView.h"
#import "LevelLogViewController.h"
@interface LevelViewController ()

@end

@implementation LevelViewController
{
    NSString *currentGrow,*todayGrow,*rankGrow;
    NSArray *rankArr,*imageArr,*growArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的等级";
    [self comeBack:nil];
    
    rankArr = [NSArray arrayWithObjects:@"等级", @"先锋队员",@"一道杠",@"两道杠",@"三道杠",@"四道杠",@"五道杠",@"老前辈", nil];
    imageArr = [NSArray arrayWithObjects:@"勋章", @"level0",@"level1",@"level2",@"level3",@"level4",@"level5",@"level6", nil];
    growArr = [NSArray arrayWithObjects: @"成长值", @"0~199",@"200~799",@"800~1999",@"2000~3999",@"4000~6999",@"7000~11999",@"12000以上", nil];
    [self initView];
    [self getMessage];
}

-(void)getMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([defaults objectForKey:@"token"]) {
        [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
        [self showHUD:@"正在加载"];
        [RSHttp requestWithURL:@"/user/growth" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
            [self hidHUD];
            NSDictionary *dict = [data valueForKey:@"msg"];
            NSInteger cgrowth = [[dict valueForKey:@"currentGrowth"]intValue];
            NSString *crank = [dict valueForKey:@"currentRank"];
            NSInteger maxgrowth = [[dict valueForKey:@"maxGrowth"] intValue];
            NSString *nextRank = [dict valueForKey:@"nextRank"];
            NSInteger ranking = [[dict valueForKey:@"ranking"] intValue];
            NSInteger growthToNextRank = [[dict valueForKey:@"growthToNextRank"] intValue];
            NSInteger growthToday = [[dict valueForKey:@"growthToday"] intValue];

            [self.progressView setProgress:(1.0 * cgrowth/maxgrowth) withInterval:0.5];
            self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", cgrowth, maxgrowth];
            self.rankLabel.text = [NSString stringWithFormat:@"全国等级排名%ld", ranking];
            NSDictionary *predictattr = [NSDictionary dictionaryWithObjectsAndKeys:
                                      textFont12, NSFontAttributeName,
                                      color155, NSForegroundColorAttributeName, nil];
            NSMutableAttributedString *predictString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"距离成为%@还有%ld成长值", nextRank, growthToNextRank] attributes:predictattr];
            [predictString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorgreen65, NSForegroundColorAttributeName, nil] range:NSMakeRange([[NSString stringWithFormat:@"距离成为%@还有", nextRank] length], [[NSString stringWithFormat:@"%ld", growthToNextRank] length])];
            self.predictionLabel.attributedText = predictString;
            
            NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                            textFont12, NSFontAttributeName,
                                           color155, NSForegroundColorAttributeName, nil];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"今日成长值%ld", growthToday] attributes:attrDict];
            [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorgreen65, NSForegroundColorAttributeName, nil] range:NSMakeRange(5, [attrStr length] - 5)];
            self.todayLabel.attributedText = attrStr;
            NSInteger i = 0;
            for(NSString *str in rankArr) {
                if([crank isEqualToString:str]) {
                    self.levelIconView.image = [UIImage imageNamed:imageArr[i]];
                }
                i++;
            }
        } failure:^(NSInteger code, NSString *errmsg) {
            [self hidHUD];
            [self alertView:errmsg];
        }];
    }

}

-(void)initView
{
    RSAccountModel *account = [RSAccountModel sharedAccount];
   
    self.tableView.left = 18;
    self.tableView.width = kUIScreenWidth - 36;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    
    
    UIView *bgView = [[UIView alloc] init];
    
    UIView *levelView = [[UIView alloc] initWithFrame:CGRectMake(0, 14, self.tableView.width, 73)];
    levelView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:levelView];

    RSHeadView *headView = [[RSHeadView alloc]initWithFrame:CGRectMake(15, 11, 49, 49)];
    [levelView addSubview:headView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(headView.right+5, headView.top, 137, 15)];
    name.text = account.realName;
    name.font = textFont14;
    [name sizeToFit];
    [levelView addSubview:name];
    
    self.levelIconView.top = name.top;
    self.levelIconView.left = name.right;
    [levelView addSubview:self.levelIconView];
    
 
    self.progressView.frame = CGRectMake(name.left, name.bottom+14, levelView.frame.size.width+levelView.frame.origin.x-150, 14);
    [levelView addSubview:self.progressView];
    
    self.countLabel.left = self.progressView.right + 5;
    self.countLabel.top = self.progressView.top;
    [levelView addSubview:self.countLabel];
    
    //~~~~~~
    self.rankLabel.top = levelView.bottom + 10;
    self.rankLabel.left = levelView.left;
    [bgView addSubview:self.rankLabel];
    
   
    self.predictionLabel.top = self.rankLabel.top;
    self.predictionLabel.right = levelView.right;
    [bgView addSubview:self.predictionLabel];
    //~~~~~~~
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(levelView.left, self.predictionLabel.bottom+30, levelView.width, 41)];
    [bgView addSubview:recordView];
    recordView.backgroundColor = [UIColor whiteColor];
    UILabel *recordText = [[UILabel alloc] initWithFrame:CGRectMake(13, 14, 83, 15)];
    recordText.text = @"成长值记录";
    recordText.textColor = color_black_333333;
    recordText.font = textFont15;
    [recordView addSubview:recordText];
    
    
    self.todayLabel.right = recordView.width - 19;
    self.todayLabel.top = 15;
    [recordView addSubview:self.todayLabel];
    [recordView addTapAction:@selector(recordLog) target:self];
    
    UIImageView *recordDetail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 30)];
    recordDetail.top = (recordView.height - recordDetail.height)/2;
    recordDetail.right = recordView.width - 5;
    recordDetail.transform = CGAffineTransformMakeRotation(M_PI);
    recordDetail.image = [UIImage imageNamed:@"newfanhui"];
    [recordView addSubview:recordDetail];
    //~~~~~~~
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(levelView.left, recordView.bottom+18, levelView.width, 121)];
    showView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:showView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, showView.width-28, 110)];
    label.textColor = color155;
    label.font = textFont12;
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              textFont12, NSFontAttributeName,
                              color155, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"如何获取成长值？\n· 成功配送并送达一个任务，增加两个成长值\n· 未送达一个任务，增加一个成长值\n· 校园CEO成长值为负责学校送达任务总数除以10，每日凌晨更新；" attributes:attrDict];
    [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont15, NSFontAttributeName, color_black_333333, NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 9)];
    [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorgreen65, NSForegroundColorAttributeName, nil] range:NSMakeRange(10, 1)];
    [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorgreen65, NSForegroundColorAttributeName, nil] range:NSMakeRange(32, 1)];
    [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorgreen65, NSForegroundColorAttributeName, nil] range:NSMakeRange(50, 1)];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    label.attributedText = attrStr;
    [label sizeToFit];
    showView.height = label.height + 26;
    [showView addSubview:label];
    bgView.height = showView.bottom + 18;

    self.tableView.tableHeaderView = bgView;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
}

-(UIImageView *) levelIconView
{
    if(_levelIconView) {
        return _levelIconView;
    }
    _levelIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    return _levelIconView;

}

-(RSProgressView *) progressView
{
    if(_progressView) {
        return _progressView;
    }
    _progressView = [[RSProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 14)];
    [_progressView setFrontcolor:colorgreen65 backColor:color232];
    [_progressView setFrontImg:@"bg_progress.png" backImg:nil];
    _progressView.layer.cornerRadius = 8;
    _progressView.layer.masksToBounds = YES;
    return _progressView;
}

-(UILabel *) todayLabel
{
    if(_todayLabel) {
        return _todayLabel;
    }
    _todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 150, 12)];
    _todayLabel.textColor = color155;
    _todayLabel.font = textFont12;
    _todayLabel.textAlignment = NSTextAlignmentRight;
    return _todayLabel;
}

-(UILabel *) countLabel
{
    if(_countLabel) {
        return _countLabel;
    }
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 58, 12)];
    _countLabel.font = textFont12;
    _countLabel.textColor = color155;
    return _countLabel;
}

-(UILabel *) rankLabel
{
    if(_rankLabel) {
        return _rankLabel;
    }
    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 113, 11)];
    _rankLabel.font = textFont12;
    _rankLabel.textColor = color155;
    return _rankLabel;
}

-(UILabel *) predictionLabel
{
    if(_predictionLabel) {
        return _predictionLabel;
    }
    _predictionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 11)];
    _predictionLabel.textColor = color155;
    _predictionLabel.font = textFont12;
    _predictionLabel.textAlignment = NSTextAlignmentRight;
    return _predictionLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addTapAction:@selector(toggleTableView) target:self];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 80, 15)];
    label.text = @"等级划分";
    label.textColor = color_black_333333;
    label.font = textFont15;
    [view addSubview:label];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 10)];
    arrow.top = label.top;
    arrow.right = view.width - 15;
    arrow.tag = 11110;
    arrow.image = [UIImage imageNamed:@"zu2x"] ;
    arrow.transform=CGAffineTransformMakeRotation(M_PI*1/2);
    [view addSubview:arrow];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.2, kUIScreenWidth-36, 0.8)];
    lineView.backgroundColor = color232;
    [view addSubview:lineView];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rankArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Level_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    NSInteger row = indexPath.row;
    cell.userInteractionEnabled = NO;
    for (int i = 0; i < 3; i++) {
        CGFloat wight = (kUIScreenWidth-36)/3;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(wight*i, 0, wight, 40)];
        label.textColor = color102;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFont12;
        [cell.contentView addSubview:label];
        
        if(row == 0) {
            label.font = textFont14;
            label.textColor = color_black_333333;
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = color232;
        [cell.contentView addSubview:line];
        
        if (i == 0) {
            label.text = rankArr[indexPath.row];
        }
        if (i == 1) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            if(row != 0) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width/2-8, 10, 15, 15)];
                image.image = [UIImage imageNamed:imageArr[indexPath.row]];
                [label addSubview:image];
                label.text = @"";
            } else {
                label.text = imageArr[row];
            }
        }
        if (i == 2) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            label.text = growArr[indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


-(void) toggleTableView
{
    if([rankArr count] != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.models = [rankArr mutableCopy];
            rankArr = [NSArray array];
            [self.tableView reloadData];
        }];
        [self.tableView viewWithTag:11110].transform = CGAffineTransformMakeRotation(M_PI*1/2);
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            rankArr = [self.models copy];
            [self.tableView reloadData];
        }];
        [self.tableView viewWithTag:11110].transform = CGAffineTransformMakeRotation(M_PI*3/2);
    }
}

-(void) recordLog
{
    LevelLogViewController *logvc = [LevelLogViewController new];
    [self.navigationController pushViewController:logvc animated:YES];
}
@end
