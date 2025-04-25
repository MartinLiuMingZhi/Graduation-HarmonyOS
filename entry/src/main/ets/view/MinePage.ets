import { CardView } from "./CardView"
import { Font } from "@ohos.arkui.UIContext"
import { SearchView } from "./SearchView"
import { PlayerComponent } from "./PlayerComponent"
import { PlayListItem } from "./PlayListItem"
import { logout } from "../apis/logout"
import { PreferencesUtil } from "../utils/PreferencesUtil"
import { promptAction, router } from "@kit.ArkUI"

@Entry
@Component
export struct MinePage {

  build() {
    Column(){
      SearchView()

      Scroll(){
         Column(){
           CardView()
           Text('我的歌单')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })

           Text('推荐歌单')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })

           Text('大家都在听')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .listDirection(Axis.Horizontal)
           .listDirection(Axis.Horizontal)
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })


         }
         .width('100%')
         .height('100%')
      }
      .scrollBar(BarState.Off)
      .height(550)

      Button('退出登录')
        .onClick(() => {
          this.handleLogout()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white_background'))
  }

  private async handleLogout(){
      try {
        const result = await logout<string>();
        if (result.code === '200') {
            await PreferencesUtil.deleteAsync('token');

            router.replaceUrl({ url: 'pages/LoginPage' });
        }else{
          promptAction.showToast({
            message: result.msg
          })
        }

      }catch (e) {
        console.error('退出登录失败:', e);
      }
  }

}