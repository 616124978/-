//
//  BelTableViewCell.m
//  Article
//
//  Created by 小强 on 16/10/26.
//  Copyright © 2016年 xiaoqiang. All rights reserved.
//

#import "BelTableViewCell.h"

@implementation BelTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 250)];
        [self.contentView addSubview:self.view];
        
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, width-20, 200)];
        [self.view addSubview:self.image];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 220, width-20, 10)];
        self.timeLabel.font =[UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        
        [self.view addSubview:self.titleLabel];
        
        self.timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(13, 245, width-20, 10)];
        self.timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        [self.view addSubview:self.timeLabel];
        self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    return self;
}


- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
