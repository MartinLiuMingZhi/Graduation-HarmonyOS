import { MIText } from "./MIText"

@Component
@Preview
export struct NationalSwiperItem{
  @State title: string = '山那边河'
  @State singer:string = '大籽'
  @State label: string = 'https://bkimg.cdn.bcebos.com/pic/d009b3de9c82d158ccbff64675530ed8bc3eb035e488?x-bce-process=image/format,f_auto/quality,Q_70/resize,m_lfit,limit_1,w_536'
  @State meta:string = '国风'

  build() {
      Flex({ direction: FlexDirection.Column}){
          // 右上角的标题和歌手信息
          Text(this.title)
            .fontWeight(FontWeight.Bold)
            .fontSize(14)
            .fontColor(Color.Gray)
            .width('100%')
            .textAlign(TextAlign.End)
            .margin({
              top: 10,
              right: 10
            })

          Text(this.singer)
            .fontSize(12)
            .fontColor(Color.Gray)
            .width('100%')
            .textAlign(TextAlign.End)


          Image(this.label)
            .width('50%')
            .aspectRatio(1)
            .borderRadius(10)
            .margin({
              top: 10
            })

          Row() {
              Column(){
                Text(this.meta)
                  .fontSize(12)
              }
              .width(24)
              .height(12)
              .borderRadius(4)
              .backgroundColor(Color.White)

              Text('大籽<<山那边河>>上线')
          }
          .width('100%')
          .height('auto')
      }
      .width('100%')
      .height('40%')
      .borderRadius(10)
      .linearGradient({
        // 0点方向顺时针旋转为正向角度，线性渐变起始角度的默认值为180°
        colors: [
          [0xf56c6c, 0.0], // 颜色断点1的颜色和比重，对应组件在180°方向上的起始位置
          [0xffffff, 1.0],// 颜色断点2的颜色和比重，对应组件在180°方向上的终点位置
        ]
      })
  }
}