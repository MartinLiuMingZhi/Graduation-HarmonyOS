import { SongItem } from "../data/SongData";
import { StyleConstants } from "../data/StyleConstants";
import { LrcEntry } from "../lyric/LrcEntry";
import { fetchLyricFromUrl, parseLrcLyric } from "../lyric/LrcUtils";
import LrcView from "../lyric/LrcView";
import { LyricScrollEffect, LyricTopPosition } from "../lyric/LyricConst";
import { Logger } from "../utils/Logger";
import { ControlAreaComponent } from "./ControlAreaComponent";

@Component
@Preview
export struct LyricsComponent{
  @StorageLink('progress') time: number = 0;
  @State progress: number = 0.01;
  @State progressText: string = '';
  @State mLrcEntryList: Array<LrcEntry> = [];
  @State lyricScrollEffect: LyricScrollEffect = LyricScrollEffect.Line;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') @Watch('getLrcEntryList') selectIndex: number = 0;
  @StorageLink('isPlay') isPlay: boolean = false;
  @Link isShowControl: boolean;
  @State intervalID: number = 0;
  @State pageShowTime: number = 0;

  private TAG: string = 'LyricsComponent';

  aboutToAppear(){
    this.getLrcEntryList();
  }

  getLrcEntryList() {
    if (!this.songList || this.selectIndex < 0 || this.selectIndex >= this.songList.length) {
      console.error('Invalid song list or select index');
      return;
    }

    try {
      const selectedSong = this.songList[this.selectIndex];
      if (selectedSong && selectedSong.lyric) {
        fetchLyricFromUrl(selectedSong.lyric)
          .then((lyricText: string) => {
            this.mLrcEntryList = parseLrcLyric(lyricText);
            Logger.info(this.TAG,this.mLrcEntryList.toString())
          })
          .catch((error: Error) => {
            console.error('Error fetching lyrics:', error);
            this.mLrcEntryList = [];
            Logger.info(this.TAG,this.mLrcEntryList.toString()+"失败")
          });
      } else {
        console.warn('Lrc URL not found for the selected song');
        this.mLrcEntryList = [];
      }
    } catch (error) {
      console.error('Error in getLrcEntryList:', error);
      this.mLrcEntryList = [];
    }
  }



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

      if (!this.isShowControl){
        ControlAreaComponent()
          .margin({
            top: $r('app.float.control_lyric_margin'),
            bottom: $r('app.float.music_component_bottom')
          })
      }
    }
    .width('100%')
    .height('100%')
    .onClick(()=>{
      this.pageShowTime = 0;
    })
  }

}