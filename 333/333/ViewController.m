//
//  ViewController.m
//  333
//
//  Created by d.c.yang on 2020/10/27.
//

#import "ViewController.h"
#import "BenTapCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *tabList;
@property (nonatomic,assign)NSInteger selectedIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _tabList = [NSMutableArray arrayWithArray:@[@"tab1",@"tab2" ,@"tab3",@"tab4",@"tab5",@"tab6",@"tab7",@"tab8",@"tab9",@"tab10",@"tab11",@"tab12",@"tab13",@"tab14",@"tab15"]];
   _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
       // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"BenTapCell" bundle:nil] forCellWithReuseIdentifier:@"BenTapCell"];
    
   
    [self addLongGesture];
    [_collectionView reloadData];
}
-(void)addLongGesture{
    UILongPressGestureRecognizer  *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longGesture.minimumPressDuration = 0.3;
    [_collectionView addGestureRecognizer:longGesture];
}
#pragma mark remove action
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
   static NSInteger index = 0;    // 记录section，防止跨section移动
    switch (longGesture.state) {
            
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该item
            NSIndexPath *AindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:AindexPath];
                index = AindexPath.section;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 更新移动位置
            NSIndexPath *BindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
                if (index == BindexPath.section) {
                    [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
                }

            break;
        }
            break;
        case UIGestureRecognizerStateEnded:
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
          
            break;
            
        default:
            [self.collectionView endInteractiveMovement];
         
            break;
    }
}
#pragma  mark collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tabList.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BenTapCell *cell = [BenTapCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.title.text = [self.tabList objectAtIndex:indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        cell.lineView.hidden = NO;
    }else{
        cell.lineView.hidden = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(100, 40);
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id objc = [self.tabList objectAtIndex:sourceIndexPath.item];
    if (self.selectedIndex == sourceIndexPath.row) {
        self.selectedIndex = destinationIndexPath.row;
    }
    [self.tabList removeObject:objc];
    [self.tabList insertObject:objc atIndex:destinationIndexPath.item];
    NSLog (@"moved data = @%",self.tabList);
}
@end
