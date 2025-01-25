import { Logger } from '../utils/Logger';
import { CommunityView } from '../view/CommunityView';
import { HomePage } from '../view/HomePage';
import { MessageView } from '../view/MessageView';
import { MinePage } from '../view/MinePage';
import { PlayerComponent } from '../view/PlayerComponent';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  @StorageLink('isShowPlay') isShowPlay: boolean = false;


  // 标签栏构建器
  @Builder tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#ff8ab5f5' : '#8a8a8a')
        .fontSize(12)
    }
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          HomePage()

        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.ic_home_select'), $r('app.media.ic_home_normal')))

        TabContent() {
          CommunityView()
        }.tabBar(this.tabBuilder('社区', 1, $r('app.media.ic_bbs_select'), $r('app.media.ic_bbs_normal')))

        TabContent(){

        }.tabBar(this.tabBuilder('漫游', 2, $r('app.media.ic_travel_select'), $r('app.media.ic_travel_normal')))

        TabContent() {
          MessageView()
        }.tabBar(this.tabBuilder('消息', 3, $r('app.media.ic_message_select'), $r('app.media.ic_message_normal')))

        TabContent() {
          MinePage()
        }.tabBar(this.tabBuilder('我的', 4, $r('app.media.ic_mine_select'), $r('app.media.ic_mine_normal')))
      }
      .animationDuration(10)
      .backgroundColor($r('app.color.white_background'))
      .onChange((index: number) => {
        if (index != 2) {
          this.currentIndex = index;
        }else {
          this.isShowPlay = true;
          Logger.info('currentIndex ' + this.currentIndex)
        }
      })
      .scrollable(false)
    }
    .width('100%')
  }
}