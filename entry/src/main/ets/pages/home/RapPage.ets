import { getSongListByGenre } from "../../apis/api"
import { Page } from "../../apis/BaseResponse"
import { Genre } from "../../data/GenreData"
import { SongItem } from "../../data/SongData"
import { ISong } from "../../view/ISong"
import { SearchView } from "../../view/SearchView"


@Preview
@Component
export struct RapPage{
  @State isLoading: boolean = false
  @State listSong:SongItem[] = []
  @State page:number = 1
  @State pageSize:number = 10
  @State recommendInitialized: boolean = false;

  aboutToAppear(): void {
    if (!this.recommendInitialized) {
      this.getSongList()
      this.recommendInitialized = true;
    }
  }

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column}){
        SearchView()
        LoadingProgress()
          .width(10)
          .height(10)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

        Swiper(){
          Image('https://y.qq.com/music/photo_new/T002R300x300M000002TFrDN2XKDE3_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
          Image('https://y.qq.com/music/photo_new/T002R300x300M000000BjlQx3hZLst_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
          Image('https://y.qq.com/music/photo_new/T002R300x300M000003d4OAx33NwPO_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
        }
        .width('100%')
        .height('30%')

        if (this.listSong.length === 0 && !this.isLoading){
          Text('暂无流行歌曲')
            .fontSize(18)
            .textAlign(TextAlign.Center)
            .width('100%')
            .margin({ top: 50 })
        }else {
          List({ space: 10,initialIndex: 0}) {
            ForEach(this.listSong, (item: SongItem) => {
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
          .scrollBar(BarState.Off)
          .margin({
            top: 10
          })
          .onReachEnd(() => {
            if (!this.isLoading && this.listSong.length >= this.page * this.pageSize) {
              this.page += 1
              this.getSongList()
            }
          })
        }
      }
    }
    .padding({
      left:10,
      right:10,
      bottom:10
    })
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)

  }

  private async getSongList(){
    this.isLoading = true
    const result = await getSongListByGenre<Page<SongItem[]>>(Genre.RAP, this.page, this.pageSize)
    if (result.code === '200') {
      if (this.page === 1) {
        this.listSong = result.data.records
      } else {
        this.listSong = [...this.listSong, ...result.data.records]
      }
      console.log('RapPage:', JSON.stringify(this.listSong))
    } else {
      console.error('请求失败:', result.msg)
    }
    this.isLoading = false
  }

}