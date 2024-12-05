
@Entry
@Component
export struct PlayerComponent{

  build() {
    Row({space:20}){
      Image($r('app.media.song_img')).width(30).borderRadius(50).margin({left:20})
      Text('overdise-14565').fontSize(14).width(156)
      Blank('10')
      Image($r('app.media.ic_play')).width(30)
      Image($r('app.media.ic_playlist')).width(30)
    }.height(60).width('100%')
  }
}