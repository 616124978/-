//
//  CHCardItemCustomView.m
//  CHCardView
//
//  Created by yaoxin on 16/10/9.
//  Copyright © 2016年 Charles. All rights reserved.
//

#define kscHeight [UIScreen mainScreen].bounds.size.height
#define kscWidth  [UIScreen mainScreen].bounds.size.width

#import "CHCardItemCustomView.h"
#import "CHCardItemModel.h"

#import "UIImageView+WebCache.h"

@interface CHCardItemCustomView ()
@property (nonatomic, strong) UIImageView *imgView;
//显示文字
@property (nonatomic,strong)UILabel *label;
//显示更新时间
@property(nonatomic,strong)UILabel *timeLabel;


@property(nonatomic,strong)UIView *backView;
@end

@implementation CHCardItemCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setItemModel:(CHCardItemModel *)itemModel {
    _itemModel = itemModel;
    
    self.label.text=itemModel.title;
    self.timeLabel.text=itemModel.timeStr;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.pic] placeholderImage:[UIImage imageNamed:@"加载中.jpg"]];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    self.backView.frame=CGRectMake(12, 0, self.bounds.size.width-20, self.bounds.size.height-5);
    self.imgView.frame = CGRectMake(15, 5, self.bounds.size.width-30, self.bounds.size.height-110);
    self.label.frame=CGRectMake(15, self.bounds.size.height-110, self.bounds.size.width-30, 90);
    self.timeLabel.frame=CGRectMake(15, self.bounds.size.height-20, self.bounds.size.width-30, 10);
}

-(UIView *)backView
{

    if (!_backView) {
        UIView *backView=[[UIView alloc]init];
        [self insertSubview:backView atIndex:0];
        _backView=backView;
        _backView.backgroundColor=[UIColor grayColor];
        backView.clipsToBounds=YES;
    }

    return _backView;
}


- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _imgView = img;
        img.clipsToBounds = YES;
    }
    return _imgView;
}

-(UILabel *)label
{
    if (!_label) {
        UILabel *label=[[UILabel alloc]init];
        [self addSubview:label];
        _label=label;
        _label.font=[UIFont systemFontOfSize:11];
        _label.numberOfLines=0;
        _label.backgroundColor=[UIColor whiteColor];
    }
    
    return _label;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *timeLabel=[[UILabel alloc]init];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
        _timeLabel.backgroundColor=[UIColor whiteColor];
        _timeLabel.font=[UIFont systemFontOfSize:9];
    }
    return _timeLabel;


}



@end
