import { ContactItem } from "../apis/message"

@Component
@Preview
export struct MessageItem {
   @Prop item: ContactItem

   build() {
     Row(){
       Image(this.item.avatar)
         .width(50)
         .height(50)
         .borderRadius(25)
         .margin({
           right: 10
         })

       Column(){
         Row(){
           Text(this.item.username)
             .fontSize(15)
             .fontWeight(FontWeight.Normal)

           Text(this.item.lastTime)
             .fontSize(12)
             .fontColor(Color.Gray)
         }
         .justifyContent(FlexAlign.SpaceBetween)
         .width('85%')
         .margin({
           bottom:5
         })

         Text(this.item.lastMessage)
           .width('80%')
           .fontSize(12)
           .fontColor(Color.Gray)
           .textOverflow({ overflow: TextOverflow.Ellipsis })
           .maxLines(1)
           .textAlign(TextAlign.Start) // 确保文本左对齐

       }
       .width('auto')
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