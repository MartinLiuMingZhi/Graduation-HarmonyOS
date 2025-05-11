
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

        //向左水平对齐
        Column(){
          Text(this.PlayListName)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)

          Text(this.PlayListSongCount)
            .alignSelf(ItemAlign.Start)
            .fontSize(12)
            .margin({
              top: 5
            })
        }
      }
      .width('auto')
      .height('auto')
    }
    .width('auto')
    .height('auto')
  }

}
