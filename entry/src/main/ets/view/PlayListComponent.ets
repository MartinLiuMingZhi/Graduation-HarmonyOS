@Preview
@Component
export struct PlayListComponent {
  @State img:  string = 'https://p1.music.126.net/Inhm4Ax4D3SD1m9i74oowg==/7942872000800668.jpg'
  @State title: string = '油门到底 放飞自己'

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