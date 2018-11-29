//
//  XJPlayerListTableView.m
//  LearnFM
//
//  Created by 何学杰 on 2018/10/17.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJPlayerListTableView.h"
#import "XJMusicTableViewCell.h"
#import "Masonry.h"
#import "GLMusicPlayViewController.h"
#import "LXToolsHTTPRequest.h"
#import "GLMusicPlayer.h"
#import "GLMiniMusicView.h"
#import "FMPrefixHeader.h"
#import "XJMusicTableViewCell.h"
#import "UIViewController+Extension.h"
#import "UIButton+EdgeInsets.h"


@implementation XJPlayerListTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubLayers];
    }
    return self;
}

- (XJNoticeHelpView *)noticeHelpView{
    if (_noticeHelpView == nil) {
//        LearnFM.framework/XJNoticeHelpView
        
//        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LearnFM.bundle"]];
        
//        _noticeHelpView = [[[NSBundle mainBundle] loadNibNamed:@"LearnFM.framework/XJNoticeHelpView" owner:nil options:nil] lastObject];
        _noticeHelpView = [[XJNoticeHelpView alloc]initWithFrame:CGRectZero];
        _noticeHelpView.backgroundColor = [UIColor clearColor];
        _noticeHelpView.layer.zPosition = 10;
        _noticeHelpView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noticeHelpView.alpha = 1.0;
        _noticeHelpView.layer.zPosition = 10;
    }
    return _noticeHelpView;
}

- (void)setCurrentVC:(UIViewController *)currentVC{
    _currentVC = currentVC;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.noticeHelpView];
    [self.noticeHelpView showNotice];
    self.noticeHelpView.alpha = 0.0;
}

- (void)addSubLayers{
    
    CGFloat allHeight = self.bounds.size.height;
    CGFloat headerHeight = 53.0;
    CGFloat footerHeight = 55.0;
    
    self.headerButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, ScreenWidth, headerHeight)];
    self.headerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.headerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerButton setTitleColor:HexRGB(0x565656) forState:UIControlStateNormal];
    [self addSubview:self.headerButton];
    self.headerButton.backgroundColor = [UIColor clearColor];
    [self.headerButton addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, headerHeight-1, ScreenWidth, 1)];
    [self addSubview:headerLine];
    headerLine.backgroundColor = HexRGB(0xf0f0f3);
    
    [self.headerButton setImagePositionWithType:LXImagePositionTypeLeft spacing:5];
    
    self.footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, allHeight-footerHeight, ScreenWidth, footerHeight)];
    [self.footerButton setTitle:@"关闭" forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.footerButton setTitleColor:HexRGB(0x565656) forState:UIControlStateNormal];
    [self addSubview:self.footerButton];
    self.footerButton.backgroundColor = [UIColor whiteColor];
    [self.footerButton addTarget:self action:@selector(footerClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self.footerButton addSubview:footerLine];
    footerLine.backgroundColor = HexRGB(0xf0f0f3);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, headerHeight, ScreenWidth, allHeight -headerHeight -footerHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];//;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[XJMusicTableViewCell class] forCellReuseIdentifier:@"musiclist"];
    [self addSubview:self.tableView];
    
//    self.tableView.layer.cornerRadius = 6;
//    self.tableView.layer.masksToBounds = YES;
    
    
    [self.headerButton setTitle:@"列表循环" forState:UIControlStateNormal];
    self.loopSate = [GLMusicPlayer defaultPlayer].loopState;
    if (self.loopSate == GLOnceLoop) {
        [self.headerButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_normal"] forState:UIControlStateNormal];
    }else{
        [self.headerButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeatone_normal"] forState:UIControlStateNormal];
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musiclist" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[GLMiniMusicView shareInstance] playedWithAnimated:YES];
    
    XJMusicList *tempMusic = self.dataArray[indexPath.row];
    if ([[GLMusicPlayer defaultPlayer].model.music_id isEqualToString:tempMusic.music_id]) {
        [GLMiniMusicView shareInstance].palyButton.selected = YES;
        [self.tableView reloadData];
        
        
    }else{
        
        NSMutableArray *musciList = [[NSMutableArray alloc] init];
        for (XJMusicList *temp in self.dataArray) {
            [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
            temp.isPlay = NO;
        }
        
        tempMusic.isPlay = YES;
        self.album.isPlay = YES;
        
        [GLMusicPlayer defaultPlayer].allArray = self.dataArray;
        [GLMusicPlayer defaultPlayer].musicListArray = musciList;
        [[GLMusicPlayer defaultPlayer] playMusicAtIndex:indexPath.row];
//        [GLMusicPlayer defaultPlayer].album = self.album;
        [GLMiniMusicView shareInstance].palyButton.selected = YES;
        
        [self.tableView reloadData];
        
//        if ([self.delegate respondsToSelector:@selector(playerListTableViewChangeMusic:)]) {
//            [self.delegate playerListTableViewChangeMusic:self];
//        }
        
    }
}

- (void)headerClick:(UIButton *)button{
    switch (self.loopSate) {
        case GLForeverLoop:
        {
            [GLMusicPlayer defaultPlayer].loopState = GLOnceLoop;
            self.loopSate = GLOnceLoop;
            
            [self.headerButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_normal"] forState:UIControlStateNormal];
            [self.headerButton setTitle:@"列表循环" forState:UIControlStateNormal];
            
            [self.noticeHelpView showNotice];
            self.noticeHelpView.midLabel.text = @"列表循环";
            
        }
            break;
        case GLOnceLoop:
        {
            [GLMusicPlayer defaultPlayer].loopState = GLForeverLoop;
            self.loopSate = GLForeverLoop;
            
            [self.headerButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeatone_normal"] forState:UIControlStateNormal];
            [self.headerButton setTitle:@"单曲循环" forState:UIControlStateNormal];
            
            [self.noticeHelpView showNotice];
            self.noticeHelpView.midLabel.text = @"单曲循环";
        }
            break;
        default:
            break;
    }
    
    [GLMusicPlayer defaultPlayer].loopState = self.loopSate;
}

- (void)footerClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(playerListTableViewClose:)]) {
        [self.delegate playerListTableViewClose:self];
    }
}

@end
