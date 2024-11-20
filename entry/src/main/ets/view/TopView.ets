@Component
export struct TopView{
  build() {
    Column(){
      Image($r('app.media.imgIcon'))
        .width(100)
        .height(100)
        .borderRadius(5)
        .margin({
          top: '120vh'
        })

      Text("音情协友")
        .fontColor(Color.Gray)
        .fontSize(14)
        .margin({
          top: '20vh',
        })

      Text("奏响心灵共鸣的交友旋律")
        .fontColor(Color.Gray)
        .fontSize(14)
        .margin({
          top: '10vh',
        })
    }
    .width('100%')
    .height('40%')
  }
}