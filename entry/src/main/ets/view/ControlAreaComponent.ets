@Component
export struct ControlAreaComponent{
  @StorageLink('isPlay') isPlay: boolean = false;
  @StorageLink('currentTime') currentTime: string = '00:00';
  @StorageLink('totalTime') totalTime: string = '00:00';
  @StorageLink('progress') value: number = 0;
  @StorageLink('progressMax') max: number = 0;
  @State playModeIndex: number = 0;
  @StorageLink('imageColor') imageColor: string = '';
  @StorageLink('pageShowTime') pageShowTime: number = 0;

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_list_cycled'))
          .controlImageBuilder()
          .width($r('app.float.twenty_four'))
        Image($r('app.media.ic_sequence'))
          .controlImageBuilder()
          .width($r('app.float.twenty_four'))
        Image($r('app.media.ic_ring'))
          .controlImageBuilder()
          .width($r('app.float.twenty_four'))
        Image($r('app.media.ic_more'))
          .controlImageBuilder()
          .width($r('app.float.twenty_four'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      Column() {
        Slider({ min: 0, max: this.max, step: 1, value: this.value })
          .blockColor($r('app.color.slider_block'))
          .selectedColor($r('app.color.slider_select'))
          .trackColor($r('app.color.slider_track'))
          .blockSize({
            width: $r('app.float.slider_block'),
            height: $r('app.float.slider_block')
          })
          .onChange((value: number, mode: SliderChangeMode) => {
            if (mode === SliderChangeMode.End || mode === SliderChangeMode.Begin) {
              // MediaService.getInstance().seek(value);
            }
            this.pageShowTime = 0;
          })
          .height($r('app.float.slider_height'))
          .margin({
            left: $r('app.float.slider_margin_sm'),
            right: $r('app.float.slider_margin_sm')
          })
          .hitTestBehavior(HitTestMode.Block)
        Row() {
          Text(this.currentTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily('HarmonyHeiTi')
            .lineHeight('14vp')
          Text(this.totalTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily('HarmonyHeiTi')
            .lineHeight('14vp')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .margin({
        top: $r('app.float.slider_margin_top'),
        bottom: '12vp'
      })

      Row() {
        Image($r('app.media.ic_public_forward'))
          .controlImageBuilder()
          .width($r('app.float.control_width'))
          .onClick(() => {
            // MediaService.getInstance().playPrevious();
            this.pageShowTime = 0;
          })
        Image(this.isPlay ? $r('app.media.ic_public_play') :  $r('app.media.ic_public_pause'))
          .controlImageBuilder()
          .width($r('app.float.image_play_width'))
          .onClick(() => {
            if (this.isPlay) {
              // MediaService.getInstance().pause();
            } else {
              // if (MediaService.getInstance().getFirst()) {
              //   MediaService.getInstance().loadAssent(0);
              // } else {
              //   MediaService.getInstance().play();
              // }
            }
            this.pageShowTime = 0;
          })
        Image($r('app.media.ic_public_next'))
          .controlImageBuilder()
          .width($r('app.float.control_width'))
          .onClick(() => {
            // MediaService.getInstance().playNextAuto(true);
            this.pageShowTime = 0;
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.float.control_padding'),
        right: $r('app.float.control_padding')
      })
    }
  }
}
@Extend(Image)
function controlImageBuilder() {
  .aspectRatio(1)
  .opacity(0.86)
  .objectFit(ImageFit.Contain)
}