@Component
export struct LyricsComponent{

  @State pageShowTime: number = 0;

  build() {
    Column(){
      Text("歌词")
    }
    .width('100%')
    .height('100%')
    .onClick(()=>{
      this.pageShowTime = 0;
    })
  }
}