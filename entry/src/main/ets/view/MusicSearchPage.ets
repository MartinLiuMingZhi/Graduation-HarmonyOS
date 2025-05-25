import { getSongByName } from "../apis/song"
import { SongItem } from "../data/SongData"
import { ISong } from "./ISong"

@Builder
export function MusicSearchPageBuilder(){
   MusicSearchPage()
}

@Preview
@Component
export struct MusicSearchPage{
  @State songList:Array<SongItem> = []
  @State name:string = ''

  build() {
    NavDestination(){
      Column(){
        Search({placeholder:'搜索你想要找的音乐'})
          .width('95%')
          .placeholderFont({
            size: 14,
          })
          .searchButton('搜索')
          .onChange((value) => {
            this.name = value
          })
          .onSubmit(() => {
            this.getSongListByName()
          })
        if (!this.songList || this.songList.length === 0 ){
          //暂无歌曲
          Text("暂无歌曲")
        }else{
          List({space:10}){
            ForEach(this.songList, (item:SongItem, index) => {
              ISong({ song:item })
            })
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }

  private async getSongListByName(){
    const result = await getSongByName<Array<SongItem>>(this.name)
    if (result.code === '200'){
      this.songList = result.data
      console.log('请求成功:', JSON.stringify(result.data))
    }else {
      console.log('请求失败:', result.msg)
    }
  }

}
