//
//  MusicLRCTableViewCell.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "MusicLRCTableViewCell.h"
#import "public.h"
#import "GLMusicLrcLable.h"
#import "XJLyricJson.h"
#import "Masonry.h"
@implementation MusicLRCTableViewCell

- (void)setLrcModel:(XJLyricJson *)lrcModel
{
    _lrcModel = lrcModel;
    
    NSString* str=lrcModel.content;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    _lrcLable.text = str;
}

- (void)reloadCellForSelect:(BOOL)select
{
    if (select) {
        _lrcLable.font = [UIFont systemFontOfSize:18];
        _lrcLable.textColor = HexRGB(0xfffffb);
    }else{
        _lrcLable.font = [UIFont systemFontOfSize:18];
//        _lrcLable.progress = 1.0;
        _lrcLable.textColor = HexRGB(0xb0da99);
    }
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}

- (void)setup {
//    [super awakeFromNib];
    // Initialization code
    
    _lrcLable = [[GLMusicLrcLable alloc]init];
    _lrcLable.textColor = HexRGB(0xb0da99);
    _lrcLable.lineBreakMode = NSLineBreakByClipping;
    _lrcLable.textAlignment = NSTextAlignmentCenter;
    _lrcLable.numberOfLines = 0;
    _lrcLable.clipsToBounds = YES;
    [self.contentView addSubview:_lrcLable];
    [_lrcLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(12);
        make.top.equalTo(self).offset(11);
        make.trailing.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-11);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
