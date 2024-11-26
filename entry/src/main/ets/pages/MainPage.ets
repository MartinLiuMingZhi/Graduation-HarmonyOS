@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;

  // 音乐播放器组件
  @Builder musicPlayerBuilder() {
    Row() {
      Image($r('app.media.ic_music'))
        .size({ width: 25, height: 25 })
      Text('正在播放: 歌曲名称')
        .fontSize(16)
        .margin({ left: 10 })
      Button('播放')
        .onClick(() => {
          // 播放音乐的逻辑
        })
        .margin({ left: 10 })
      Button('暂停')
        .onClick(() => {
          // 暂停音乐的逻辑
        })
        .margin({ left: 10 })
    }
    .width('100%')
    .height(50)
    .padding(10)
    .backgroundColor('#f0f0f0')
  }

  // 标签栏构建器
  @Builder tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#ff8ab5f5' : '#8a8a8a')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.ic_home_select'), $r('app.media.ic_home_normal')))

        TabContent() {
        }.tabBar(this.tabBuilder('社区', 1, $r('app.media.ic_bbs_select'), $r('app.media.ic_bbs_normal')))

        TabContent() {
        }.tabBar(this.tabBuilder('消息', 2, $r('app.media.ic_message_select'), $r('app.media.ic_message_normal')))

        TabContent() {
        }.tabBar(this.tabBuilder('我的', 3, $r('app.media.ic_mine_select'), $r('app.media.ic_mine_normal')))
      }
      .animationDuration(10)
      .backgroundColor($r('app.color.white_background'))
      .onChange((index: number) => {
        this.currentIndex = index
      })
      // .scrollable(false)
    }
    .width('100%')
  }
}