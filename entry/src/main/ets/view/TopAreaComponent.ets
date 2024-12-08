@Component
export struct TopAreaComponent {
  @Link isShowPlay: boolean;

  build() {
    Row() {
      Image($r('app.media.ic_back_down'))
        .width($r('app.float.common_iamge'))
        .height($r('app.float.common_iamge'))
        .onClick(() => {
          this.isShowPlay = false;
        })
      Image($r('app.media.ic_music_share'))
        .width($r('app.float.control_image_lg'))
        .height($r('app.float.control_image_lg'))
        .objectFit(ImageFit.Contain)
    }
    .height($r('app.float.info_margin_top_sm'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}