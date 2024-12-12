import { ControlAreaComponent } from "./ControlAreaComponent"

@Component
export struct MusicInfoComponent{

  build() {
    Column() {
      this.CoverInfo()
      this.MusicInfo()
      Blank()
         ControlAreaComponent()
    }
    .height('100%')
    .width('100%')
    .clip(false)
  }

  @Builder
  CoverInfo() {
    Row() {
      Image($r('app.media.song_img'))
        .width('100%')
        .aspectRatio(1)
        .borderRadius($r('app.float.cover_radius_label'))
        .shadow({
          radius: $r('app.float.shadow_radius'),
          color: $r('app.color.shadow_color'),
          offsetX: 0,
          offsetY: 8
        })
        .margin($r('app.float.lyric_margin_right_sm'))
    }
  }

  @Builder
  MusicInfo() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('泡沫')
          .fontSize($r('app.float.title_font_play'))
          .fontColor(Color.White)
          .opacity(0.86)
          .fontWeight(FontWeight.Bold)
          .fontFamily('HarmonyHeiTi-Bold')
        // Image($r('app.media.ic_public_likes'))
        //   .width($r('app.float.likes_image'))
        //   .height($r('app.float.likes_image'))
        //   .objectFit(ImageFit.Contain)
        //   .fillColor(Color.White)
        //   .opacity(0.86)
      }

      Text('邓紫棋G.E.M')
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.font_fourteen') )
        .fontColor($r('app.color.play_text_color'))
        .fontFamily('HarmonyHeiTi')
        .margin({ top: $r('app.float.music_text_margin_top') })
        .width('100%')
        .fontWeight(FontWeight.Regular)
    }
    .margin({ top: $r('app.float.music_info_margin_top') })
  }

}

