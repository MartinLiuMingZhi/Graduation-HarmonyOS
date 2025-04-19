@Component
@Preview
export struct ISong{
  @Prop img: string
  @Prop name: string
  @Prop singer: string
  build(){
    Row(){
      Image(this.img)
        .width(50)
        .height(50)
        .borderRadius(10)
        .margin({
          left: 20,
          right: 20
        })
      Column(){
        Text(this.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Text(this.singer)
          .fontSize(12)
      }
      .margin({
        left: 20
      })
    }
    .width('100%')
    .height('auto')
  }
}