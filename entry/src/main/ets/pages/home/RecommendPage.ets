import { Page } from "../../apis/BaseResponse"
import { getRandomSong, getSongListByGenre } from "../../apis/song"
import { Genre } from "../../data/GenreData"
import { SongItem } from "../../data/SongData"
import { ISong } from "../../view/ISong"
import { PlayListComponent } from "../../view/PlayListComponent"
import { SearchView } from "../../view/SearchView"

@Entry
@Component
export struct RecommendPage {
  @State playListItems: SongItem[] = []
  @State songListItems: SongItem[] = []
  @State isLoading: boolean = false
  @State page:number = 1
  @State pageSize:number = 10
  @State recommendInitialized: boolean = false;

  aboutToAppear(): void {
    if (!this.recommendInitialized) {
      this.getRecommend(1,6)
      this.getSongList()
      this.recommendInitialized = true
    }
  }

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
          ForEach(this.playListItems, (item: SongItem) => {
            PlayListComponent({ img: item.label, title: item.title})
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
        List({space:10}) {
          ForEach(this.songListItems, (item: SongItem) => {
            ListItem() {
              ISong({ song: item})
            }
          })

          // 可选：添加底部加载提示
          if (this.isLoading) {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Center }) { // 使用 Flex 布局居中内容
                LoadingProgress()
                  .width(50)
                  .height(50)
                  .margin({ top: 10,bottom: 10 })
              }

            }
          }
        }
        .width('100%')
        .layoutWeight(1)
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .scrollBar(BarState.Off)
        .onReachEnd(() => {
          if (!this.isLoading && this.songListItems.length >= this.page * this.pageSize) {
            this.page += 1
            this.getSongList()
          }
        })
      }
    }
    .padding({
      left:10,
      right:10,
      bottom:10
    })
    .width('100%')
    .height('100%' )
    .scrollBar(BarState.Off)
  }

  private async getSongList(){
    console.log('正在请求第', this.page, '页数据');
    this.isLoading = true
    const result = await getRandomSong<Page<SongItem[]>>(this.page, this.pageSize)
    if (result.code === '200') {
      if (this.page === 1) {
        this.songListItems = result.data.records
      } else {
        this.songListItems = [...this.songListItems, ...result.data.records]
      }
      console.log('RecommendPage:', JSON.stringify(this.songListItems))
    } else {
      console.error('请求失败:', result.msg)
    }
    this.isLoading = false
  }

  private async getRecommend(page:number,pageSize:number){
    const result = await getRandomSong<Page<SongItem[]>>(page,pageSize)
    if (result.code === '200') {
      this.playListItems = result.data.records
      console.log('RecommendPage2:', JSON.stringify(this.playListItems))
    } else {
      console.error('请求失败:', result.msg)
    }
  }
}
