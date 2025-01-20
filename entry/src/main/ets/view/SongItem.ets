@Component
@Preview
export struct SongItem{
  @State song_name:string = '泡沫'

  build() {
    Column(){
      Text(this.song_name)
        .fontSize(12)
        .fontColor(Color.Black)

      ImageAnimator()
    }
    .width('100%')
    .height('auto')
  }
}