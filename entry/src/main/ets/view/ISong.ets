import { SongItem } from "../data/SongData"
import { SongRepository } from "../data/SongRepository"
import { MediaService } from "../service/MediaService"


@Component
@Preview
export struct ISong{
  @Prop song:SongItem

  build(){
    Row(){
      Row({space: 20}){
        Image(this.song.label)
          .width(50)
          .height(50)
          .borderRadius(10)

        Column(){
          Text(this.song.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)

          Text(this.song.singer)
            .fontSize(12)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)
        }
      }
      .width('70%')
      .margin({
        left: 10
      })
      .justifyContent(FlexAlign.Start)

      Row(){
        SymbolGlyph($r('sys.symbol.play_round_rectangle_fill'))
          .fontSize(30)
          .fontColor([$r('app.color.light_blue')])
      }
      .width('25%')
      .justifyContent(FlexAlign.End)
      .margin({
        right: 20
      })

    }
    .width('100%')
    .height('auto')
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(()=>{
      this.handleSongClick()
    })
  }

  private handleSongClick(): void {
    MediaService.getInstance().addSongToPlaylist(this.song)
  }

}