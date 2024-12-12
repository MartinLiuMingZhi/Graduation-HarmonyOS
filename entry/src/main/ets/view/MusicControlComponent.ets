import { LyricsComponent } from "./LyricsComponent";
import { MusicInfoComponent } from "./MusicInfoComponent";
import { TopAreaComponent } from "./TopAreaComponent";

@Preview
@Component
export struct MusicControlComponent{

  @State isShowPlay:boolean = false;
  @StorageLink('topArea') topArea: number = 0;
  @StorageLink('bottomArea') bottomArea: number = 0;

  build() {
    Stack() {
      Image($r('app.media.song_img'))
        .size({
          height: '120%'
        })
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .opacity(0.5)

      Row(){
        Stack({ alignContent: Alignment.TopStart }) {
          Swiper() {
            MusicInfoComponent()
              .margin({
                top: $r('app.float.music_component_top'),
                bottom: $r('app.float.music_component_bottom')
              })
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })
            LyricsComponent()
              .margin({
                top: $r('app.float.margin_lyric')
              })
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })
          }
          .height('100%')
          .indicator(
            new DotIndicator()
              .top($r('app.float.options_padding'))
              .selectedColor($r('app.color.select_swiper'))
              .color($r('app.color.slider_track'))
          )
          .clip(false)
          .loop(false)

          TopAreaComponent({ isShowPlay: this.isShowPlay })
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding')
            })
        }
        .height('100%')
      }
      .padding({
        bottom: this.bottomArea,
        top: this.topArea
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.player_background'))
  }
}