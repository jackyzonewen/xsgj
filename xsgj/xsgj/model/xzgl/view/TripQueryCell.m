//
//  TripQueryCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripQueryCell.h"
#import "TripInfoBean.h"

@interface TripQueryCell ()

@property (strong, nonatomic) UIImageView *ivBackground;
@property (strong, nonatomic) UIImageView *ivBackgroundSelect;

- (void)_initialize;

@end

@implementation TripQueryCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([TripQueryCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 56.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _initialize];
}

- (void)_initialize
{
    //TODO: 设置所有控件默认风格
    self.lblTitle.font = [UIFont systemFontOfSize:17.f];
    self.lblTitle.textColor = HEX_RGB(0x050505);
    self.lblTitle.backgroundColor = [UIColor clearColor];
    
    self.lblDetail.font = [UIFont systemFontOfSize:12.f];
    self.lblDetail.textColor = HEX_RGB(0x989d9e);
    self.lblDetail.backgroundColor = [UIColor clearColor];
    
    self.lblPrompt.font = [UIFont systemFontOfSize:15.f];
    self.lblPrompt.textColor = HEX_RGB(0x989d9e);
    self.lblPrompt.backgroundColor = [UIColor clearColor];
    
    self.lblState.font = [UIFont systemFontOfSize:12.f];
    self.lblState.backgroundColor = [UIColor clearColor];
    
    // 设置选中效果
    self.ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    self.ivBackgroundSelect = [[UIImageView alloc] initWithFrame:self.bounds];

    self.backgroundView = self.ivBackground;
    self.selectedBackgroundView = self.ivBackgroundSelect;
    self.cellStyle = MID;
}

- (void)setCellStyle:(TripQueryCellStyle)cellStyle
{
    if (_cellStyle != cellStyle) {
        
        _cellStyle = cellStyle;
        switch (cellStyle) {
            case TOP:{
                UIImage *image = [UIImage imageNamed:@"table_part1"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackground.image = image;
                
                UIImage *imageSelect = [UIImage imageNamed:@"table_part1_s"];
                imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackgroundSelect.image = imageSelect;
            }
                break;
            case MID:{
                // 缓存中间高亮的图片
                UIImage *image = [UIImage imageNamed:@"table_part2"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackground.image = image;
                
                UIImage *imageSelect = [UIImage imageNamed:@"table_part2_s"];
                imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackgroundSelect.image = imageSelect;
            }
                break;
            case BOT:{
                UIImage *image = [UIImage imageNamed:@"table_part3"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackground.image = image;
                
                UIImage *imageSelect = [UIImage imageNamed:@"table_part3_s"];
                imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackgroundSelect.image = imageSelect;
            }
                break;
            case SINGLE:{
                UIImage *image = [UIImage imageNamed:@"table_main_n"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackground.image = image;
                
                UIImage *imageSelect = [UIImage imageNamed:@"table_main_s"];
                imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
                self.ivBackgroundSelect.image = imageSelect;
            }
                break;
            default:
                break;
        }
        
        [self setNeedsDisplay];
    }
}

@end

@implementation TripQueryCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    TripInfoBean *bean = (TripInfoBean *)data;
    if (self.isApproval) {
        self.lblTitle.text = bean.USER_NAME;
    } else {
        self.lblTitle.text = bean.TITLE;
    }
    self.lblDetail.text = bean.APPLY_TIME;
    
    // 0:未审批 1:已通过 2:未通过
    if ([bean.APPROVE_STATE intValue] == 0) {
        self.lblState.text = @"待审";
        self.lblState.textColor = HEX_RGB(0x3cadde);
        self.ivState.image = [UIImage imageNamed:@"stateicon_wait"];
    } else if ([bean.APPROVE_STATE intValue] == 1) {
        self.lblState.text = @"通过";
        self.lblState.textColor = HEX_RGB(0x5fdd74);
        self.ivState.image = [UIImage imageNamed:@"stateicon_pass"];
    } else {
        self.lblState.text = @"驳回";
        self.lblState.textColor = HEX_RGB(0xff9b10);
        self.ivState.image = [UIImage imageNamed:@"stateicon_nopass"];
    }
}

@end
