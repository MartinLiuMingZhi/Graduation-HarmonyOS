import { SongItem } from "../data/SongData";
import { StyleConstants } from "../data/StyleConstants";
import { LrcEntry } from "../lyric/LrcEntry";
import LrcView from "../lyric/LrcView";
import { LyricScrollEffect, LyricTopPosition } from "../lyric/LyricConst";

@Component
@Preview
export struct LyricsComponent{
  @StorageLink('progress') time: number = 0;
  @State pageShowTime: number = 0;
  @State mLrcEntryList: Array<LrcEntry> = [];
  @State lyricScrollEffect: LyricScrollEffect = LyricScrollEffect.Line;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') @Watch('getLrcEntryList') selectIndex: number = 0;

  build() {
    Column(){
      Row(){
        Image(this.songList[this.selectIndex].label)
          .width($r('app.float.label_width_sm'))
          .borderRadius($r('app.float.label_border'))
          .margin({
            right: $r('app.float.label_margin_right')
          })

        Column() {
          Text(this.songList[this.selectIndex].title)
            .fontSize( $r('app.float.title_font_sm'))
            .fontColor(Color.White)
            .fontWeight(700)
            .fontFamily('HarmonyHeiTi-Bold')

          Text(this.songList[this.selectIndex].singer)
            .fontSize( $r('app.float.title_font_sm'))
            .fontColor($r('app.color.singer_text'))
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .margin({
              top: $r('app.float.singer_margin_top')
            })

        }
        .alignItems(HorizontalAlign.Start)

      }
      .width(StyleConstants.FULL_WIDTH)
      .justifyContent(FlexAlign.Start)
      .margin({
          top: $r('app.float.info_margin_top_sm'),
          bottom: $r('app.float.info_margin_bottom')
        })

      LrcView({
        lyricMilliSecondsTime: this.time,
        mLrcEntryList: this.mLrcEntryList,
        lyricScrollEffect: this.lyricScrollEffect,
        lyricTopPosition: LyricTopPosition.Middle
      })
        .layoutWeight(1)


    }
    .width('100%')
    .height('100%')
    .onClick(()=>{
      this.pageShowTime = 0;
    })
  }

  getLrcEntryList(changedPropertyName: string) {
  }
}