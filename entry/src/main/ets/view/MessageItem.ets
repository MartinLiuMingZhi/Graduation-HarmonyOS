@Component
@Preview
export struct MessageItem {
   @State img: string | Resource = $r('app.media.song_img');
   @State title: string = '时间回答所有';
   @State content: string  = '时间回答所有撒娇啥叫萨哈叫啥撒谎吉萨洒家杀价杀手卡萨看啥看啥课件萨克的骄傲看得见啊看得见啊案件扩大的急啊卡的';
   @State time: string = '2024-09-23 12:00';

   build() {
     Row(){
       Image(this.img)
         .width(30)
         .height(30)
         .borderRadius(15)
         .margin({
           right: 10
         })

       Column(){
         Row(){
           Text(this.title)
             .fontSize(14)
             .fontWeight(FontWeight.Normal)

           Text(this.time)
             .fontSize(8)
             .fontColor(Color.Gray)
             .margin({
               right:10
             })
         }
         .justifyContent(FlexAlign.SpaceBetween)
         .width('90%')
         .margin({
           bottom:5
         })

         Text(this.content)
           .width('80%')
           .fontSize(8)
           .fontColor(Color.Gray)
           .textOverflow({ overflow: TextOverflow.Ellipsis })
           .maxLines(1)
           .textAlign(TextAlign.Start) // 确保文本左对齐

       }
       .width('100%')
       .alignItems(HorizontalAlign.Start)
     }
     .width('100%')
     .height('auto')
     .padding({
       left: 10,
       right: 10,
       top: 10,
       bottom: 10
     })
   }
}