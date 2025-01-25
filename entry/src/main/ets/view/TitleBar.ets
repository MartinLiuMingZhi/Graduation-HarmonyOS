@Component
export struct TitleBar {
  @Prop title: string ;
  @Prop leftIcon: string | Resource;
  @Prop rightIcon:string | Resource;

  build(){
    Column(){
      Row({space: 8}) {
        if (this.leftIcon) {
          Image(this.leftIcon)
            .width(24)
            .height(24)
            .alignSelf(ItemAlign.Center) // 修改对齐方式为居中
        }

        Text(this.title)
          .fontSize(16)
          .fontColor('#000000') // 修改字体颜色为黑色
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center)

        if (this.rightIcon) {
          Image(this.rightIcon)
            .width(24)
            .height(24)
            .alignSelf(ItemAlign.Center) // 修改对齐方式为居中
        }
      }
      .width('100%')
      .height(48)
      .backgroundColor('#FFFFFF') // 修改背景颜色为白色或其他需要的颜色
      .padding({
        left: 8,
        right: 8
      })
      // 添加背景图片（假设图片资源为'app.media.bg_image'）
      .borderRadius(8) // 添加圆角
    }
  }
}