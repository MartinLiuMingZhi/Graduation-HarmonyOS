@Component
@Preview
export struct ISong{
  @Prop img: string
  @Prop name: string
  @Prop singer: string
  build(){
    Row(){
      Row({space: 20}){
        Image(this.img)
          .width(50)
          .height(50)
          .borderRadius(10)

        Column(){
          Text(this.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)

          Text(this.singer)
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
  }
}