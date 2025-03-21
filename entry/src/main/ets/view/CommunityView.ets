import { DynamicItem } from "./DynamicItem";
import { TitleBar } from "./TitleBar"
import { router } from "@kit.ArkUI";
import { DynamicDataSource, DynamicItemData } from "../data/DynamicDataSource";


@Preview
@Component
export struct CommunityView {
  @State items: DynamicItemData[] = new Array(100).fill(null).map((_: null, i: number): DynamicItemData => ({
    dynamic_title: `动态标题 ${i + 1}`,
    dynamic_img: 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0',
    dynamic_avatar: 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0',
    dynamic_name: `用户 ${i + 1}`,
    dynamic_likes: `${Math.floor(Math.random() * 1000)}`,
    dynamic_like_state: Math.random() > 0.5,
  }));
  private dataSource: DynamicDataSource = new DynamicDataSource(this.items);

  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  @State minSize: number = 80;
  @State maxSize: number = 180;
  private itemWidthArray: number[] = [];
  private itemHeightArray: number[] = [];

  // 计算FlowItem宽/高
  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  // 设置FlowItem宽/高数组
  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemWidthArray.push(this.getSize());
      this.itemHeightArray.push(this.getSize());
    }
  }


  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }){
      Column(){
          TitleBar({
            title: '社区',
            leftIcon: $r('app.media.ic_vip'),
            rightIcon: $r('app.media.ic_add'),
            rightIconClick: () => {
              this.pathStack.pushPathByName('PostEditorPage',null)
              console.log('点击了添加按钮')
            }
          })

          WaterFlow(){
            // 使用LazyForEach需要实现IDataSource接口
            LazyForEach(this.dataSource, (item: DynamicItemData,index:number) => {
              FlowItem(){
                DynamicItem({
                  dynamic_title: item.dynamic_title,
                  dynamic_img: item.dynamic_img,
                  dynamic_avatar: item.dynamic_avatar,
                  dynamic_name: item.dynamic_name,
                  dynamic_likes: item.dynamic_likes,
                  dynamic_like_state: item.dynamic_like_state
                })
              }
              // 瀑布流项目样式
              .width('100%')
              .height(this.itemHeightArray[index % 100])
              .margin({ bottom: 10 })
            }, (item: DynamicItemData,index:number) => index.toString())
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(5)
          .rowsGap(10)
          .scrollBar(BarState.Off)
          .backgroundColor($r('app.color.white_background'))
          .margin({ left: 5, right: 5 })

      }
    }
    .width('100%')
    .height('100%')
  }
}