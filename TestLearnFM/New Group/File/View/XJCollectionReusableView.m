//
//  XJCollectionReusableView.m
//  LearnFM
//
//  Created by 何学杰 on 2018/10/9.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJCollectionReusableView.h"
#import "Masonry.h"
#import "public.h"

@implementation XJCollectionReusableView


-(instancetype)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.columnLabel = [UILabel new];
    self.columnLabel.font = [UIFont systemFontOfSize:19.0];
    self.columnLabel.textColor = HexRGB(0x565656);
    [self addSubview:self.columnLabel];
    [self.columnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.top.equalTo(self).offset(15);
    }];
}

@end
