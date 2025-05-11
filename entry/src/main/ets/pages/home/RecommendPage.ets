import { ISong } from "../../view/ISong"
import { PlayListComponent } from "../../view/PlayListComponent"
import { SearchView } from "../../view/SearchView"

@Entry
@Component
export struct RecommendPage {
  @State playListItems: number[] = [0, 1, 2, 3, 4, 5]
  @State songListItems: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  build() {
    Scroll() {
      Column() {
        // 搜索栏
        SearchView()
          .width('100%')

        // 推荐歌单标题
        Text('推荐歌单')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)

        // 推荐歌单列表
        List({space:10}) {
          ForEach(this.playListItems, (index: number) => {
            PlayListComponent()
              .margin({ bottom: 10, })
          })
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .height(200)

        // 令人心动的歌曲标题
        Text('令人心动的歌曲')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 10 })
          .alignSelf(ItemAlign.Start)

        // 歌曲列表
        List() {
          ForEach(this.songListItems, (index: number) => {
            ISong({
              img: 'https://p1.music.126.net/5twdZbLLMuB7P_siWd31sA==/109951168603076604.jpg',
              name: `心动歌曲 ${index + 1}`,
              singer: `歌手${index}`
            })
              .width('100%')
              .margin({ bottom: 8 })
          })
        }
        .width('100%')
        .height('auto')
      }
    }
    .padding(10)
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }
}
