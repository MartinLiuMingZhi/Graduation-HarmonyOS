import { MediaService } from '../service/MediaService';
import { Logger } from '../utils/Logger';
import { CommunityView } from '../view/CommunityView';
import { HomePage } from '../view/HomePage';
import { MessageView } from '../view/MessageView';
import { MinePage } from '../view/MinePage';
import { PlayerComponent } from '../view/PlayerComponent';

@Builder
export function  MainPageBuilder(){
  MainPage()
}

@Component
export struct MainPage {
  @State currentIndex: number = 0;
  @StorageLink('isShowPlay') isShowPlay: boolean = false;
  private isInitialized = false;


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

  aboutToAppear() {
    if (!this.isInitialized) {
      this.initializeMediaService();
      this.isInitialized = true;
    }
  }

  private async initializeMediaService() {
    const mediaService = MediaService.getInstance();
    // 如果有异步初始化逻辑，可以在这里等待它完成
    // 例如 await mediaService.loadSongList();
  }

  build() {
    NavDestination(){
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          HomePage()
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.ic_home_select'), $r('app.media.ic_home_normal')))

        TabContent() {
          CommunityView()
            .padding({ bottom: 40 }) // 给 CommunityView 添加底部内边距
        }.tabBar(this.tabBuilder('社区', 1, $r('app.media.ic_bbs_select'), $r('app.media.ic_bbs_normal')))

        TabContent() {
        }.tabBar(this.tabBuilder('漫游', 2, $r('app.media.ic_travel_select'), $r('app.media.ic_travel_normal')))

        TabContent() {
          MessageView()
            .padding({ bottom: 40 }) // 给 MessageView 添加底部内边距
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
        } else {
          this.isShowPlay = true;
          Logger.info('currentIndex ' + this.currentIndex)
        }
      })
      .scrollable(false)
    }
    .hideTitleBar(true)
  }
}