
@Entry
@Component
export struct PlayListItem{

  @State PlayListName : string = '英文歌'
  @State PlayListCover : string = 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg'
  @State PlayListSongCount : string = '3首'

  build() {
    Column() {
      Row() {
        Image(this.PlayListCover)
          .width(50)
          .height(50)
          .margin({
            left: 10,
            right: 10
          })
          .borderRadius(10)

        Column(){
          Text(this.PlayListName)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)

          Text(this.PlayListSongCount)
            .fontSize(12)
            .margin({
              top: 5
            })
            .textAlign(TextAlign.Start)

        }
      }
      .width('100%')
      .height('auto')
    }
    .width('100%')
    .height('auto')
  }

}
