@Preview
@Component
export struct PlayListComponent {
  @Prop img:  string
  @Prop title: string

  build() {
    Column() {
      Image(this.img)
        .width(140)
        .height(160)
        .borderRadius(10)

      Text(this.title)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .margin({
          top: 5
        })
    }
    .width('140')
    .height('auto')
  }
}