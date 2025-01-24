@Component
@Preview
export struct DynamicItem{

  @State dynamic_title:string = '泡沫';
  @State dynamic_img:string = 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0';
  @State dynamic_avatar:string = 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0';
  @State dynamic_name:string = '青春勿语';
  @State dynamic_likes:string = '1000';
  @State dynamic_like_state:boolean = false;

  build() {
    Column({space:10}) {
      Image(this.dynamic_img)
        .objectFit(ImageFit.Contain)
        .width('100%')
        .height('auto')

      Text(this.dynamic_title)
        .fontWeight(FontWeight.Bold)
        .fontSize(16)
        .maxLines(2)
        .margin({
          left: 5
        })
        .textAlign(TextAlign.Start)

      Row() {
        Row(){
          Image(this.dynamic_avatar)
            .width(20)
            .height(20)
            .borderRadius(10)
            .margin({
              left: 5
            })

          Text(this.dynamic_name)
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({
              left: 5
            })
        }


        Row() {
          Image(this.dynamic_like_state ? $r('app.media.ic_like_select') : $r('app.media.ic_like_normal'))
            .width(10)
            .height(10)
            .margin({
              right: 5
            })

          Text(this.dynamic_likes)
            .fontSize(12)
            .fontColor(this.dynamic_like_state ? Color.Red : Color.Gray)
            .margin({
              right: 5
            })
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({
        bottom:5
      })

    }
    .width('100%')
    .height('auto')
  }
}