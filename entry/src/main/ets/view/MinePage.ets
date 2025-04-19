import { CardView } from "./CardView"
import { Font } from "@ohos.arkui.UIContext"
import { SearchView } from "./SearchView"
import { PlayerComponent } from "./PlayerComponent"
import { PlayListItem } from "./PlayListItem"

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

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white_background'))
  }
}