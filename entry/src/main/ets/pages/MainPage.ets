import { MediaService } from '../service/MediaService';
import { Logger } from '../utils/Logger';
import { CommunityView } from '../view/CommunityView';
import { HomePage } from '../view/HomePage';
import { MessageView } from '../view/MessageView';
import { MinePage } from '../view/MinePage';
import { PlayerComponent } from '../view/PlayerComponent';

@Entry
@Component
export struct MainPage {
  @State currentIndex: number = 0;
  @StorageLink('isShowPlay') isShowPlay: boolean = false;
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();


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
    Navigation(this.pathStack){
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            HomePage()
              .padding({ bottom: 48 })
            PlayerComponent()
          }
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.ic_home_select'), $r('app.media.ic_home_normal')))

        TabContent() {
          Column(){
            CommunityView()
              .padding({ bottom: 88 }) // 给 CommunityView 添加底部内边距
              PlayerComponent()
          }
        }.tabBar(this.tabBuilder('社区', 1, $r('app.media.ic_bbs_select'), $r('app.media.ic_bbs_normal')))

        TabContent() {
          // 点击漫游时显示之前的界面
          if (this.currentIndex === 0) {
            Column() {
              HomePage()
                .padding({ bottom: 48 });
              PlayerComponent();
            }
          } else if (this.currentIndex === 1) {
            Column() {
              CommunityView()
                .padding({ bottom: 88 });
              PlayerComponent();
            }
          } else if (this.currentIndex === 3) {
            Column() {
              MessageView()
                .padding({ bottom: 48 });
            }
          } else if (this.currentIndex === 4) {
            Column() {
              MinePage()
                .padding({ bottom: 48 });
              PlayerComponent();
            }
          }
        }.tabBar(this.tabBuilder('漫游', 2, $r('app.media.ic_travel_select'), $r('app.media.ic_travel_normal')))

        TabContent() {
          MessageView()
            .padding({ bottom: 48 })
        }.tabBar(this.tabBuilder('消息', 3, $r('app.media.ic_message_select'), $r('app.media.ic_message_normal')))

        TabContent() {
          Column(){
            MinePage()
              .padding({ bottom: 48 }) // 给 MinePage 添加底部内边距
              PlayerComponent()
          }
        }.tabBar(this.tabBuilder('我的', 4, $r('app.media.ic_mine_select'), $r('app.media.ic_mine_normal')))
      }
      .animationDuration(10)
      .backgroundColor($r('app.color.white_background'))
      .onChange((index: number) => {
        if (index != 2) {
          this.currentIndex = index;
        } else {
          this.isShowPlay = true;
          Logger.info('currentIndex ' + this.currentIndex)
        }
      })
      .scrollable(false)
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}