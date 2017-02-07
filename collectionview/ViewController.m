//
//  ViewController.m
//  collectionview
//
//  Created by 王望 on 2017/2/6.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "ViewController.h"

@protocol UICollectionViewDelegateAlignmentCenterLayout <UICollectionViewDelegate>
@optional

- (CGSize)ac_collectionView:(UICollectionView *)collectionView sizeForlayout:(UICollectionViewLayout*)collectionViewLayout;

@end

@interface AlignmentCenterLayout : UICollectionViewLayout

@property (nonatomic) IBInspectable NSInteger numberOfColumns;

/**
 
 # <-interItemSpacing-> #
 ^
 |
 lineSpacing
 |
 v
 # # # # # # # # # # # #
 
 */
@property (nonatomic) IBInspectable CGFloat interItemSpacing;///每一列的间距

@property (nonatomic) IBInspectable CGFloat lineSpacing;///每一行的间距

@end

@interface AlignmentCenterLayout ()

@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes*> *attributes;

@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) CGSize itemSize;

@end

@implementation AlignmentCenterLayout
- (void)setInterItemSpacing:(CGFloat)interItemSpacing{
    _interItemSpacing = interItemSpacing;
}

- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns{
    _numberOfColumns = numberOfColumns;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.attributes = [NSMutableArray array];
    self.count = [self.collectionView numberOfItemsInSection:0];
    
    if (_numberOfColumns > 0) {
        id<UICollectionViewDelegateAlignmentCenterLayout> ac_delegate = (id<UICollectionViewDelegateAlignmentCenterLayout>)self.collectionView.delegate;
        self.itemSize = [ac_delegate ac_collectionView:self.collectionView sizeForlayout:self];
    }
    NSInteger index = 0;
    while (index++,index <= self.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index-1 inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributes addObject:attribute];
    }
}

- (CGSize)collectionViewContentSize{
    NSInteger row = self.count % self.numberOfColumns == 0 ? self.count / self.numberOfColumns : self.count / self.numberOfColumns + 1;
    CGFloat width  = _numberOfColumns * self.itemSize.width + (_numberOfColumns - 1) * self.interItemSpacing;
    CGFloat height = row * self.itemSize.height + (row - 1) * self.lineSpacing;
    return CGSizeMake(width, height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger remainder = self.count % self.numberOfColumns;///余数
    NSInteger row = remainder == 0 ? self.count / self.numberOfColumns : self.count / self.numberOfColumns + 1;
    CGFloat x,y = 0;
    CGSize size = self.itemSize;
    if (indexPath.item < self.count - remainder) {///正常排列
        x = 0.0 + (indexPath.item % self.numberOfColumns) * (self.itemSize.width + self.interItemSpacing);
        y = 0.0 + (indexPath.item / self.numberOfColumns) * (self.itemSize.height + self.lineSpacing);
    }else{///居中处理
        CGSize line_size = CGSizeMake(size.width  + (remainder - 1) * (size.width + self.interItemSpacing), size.height);
        CGFloat line_x = (self.collectionViewContentSize.width - line_size.width)/2.0;
        CGFloat line_y = 0.0 + (row - 1) * (self.itemSize.height + self.lineSpacing);
        y = line_y;
        x = line_x + (indexPath.item % self.numberOfColumns) * (self.itemSize.width + self.interItemSpacing);
    }
    attribute.frame = CGRectMake(x, y, size.width, size.height);
    return attribute;
}

@end

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateAlignmentCenterLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger index = 0;
    while (index++,index <= 10) {
        
        NSLog(@"%zd",index);
    }
    AlignmentCenterLayout *layout = (AlignmentCenterLayout *)self.collectionView.collectionViewLayout;
    NSLog(@"%.2f",layout.lineSpacing);
    NSLog(@"%.2f",layout.interItemSpacing);
    NSLog(@"%zd",layout.numberOfColumns);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlignmentCenterLayout" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGSize)ac_collectionView:(UICollectionView *)collectionView sizeForlayout:(UICollectionViewLayout*)collectionViewLayout{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 4 * 16) / 5;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

@end
