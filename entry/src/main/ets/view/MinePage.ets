import { CardView } from "./CardView"
import { Font } from "@ohos.arkui.UIContext"
import { SearchView } from "./SearchView"

@Entry
@Component
export struct MinePage {

  build() {
    Column(){
      SearchView()

      Scroll(){
         Column(){
           CardView()
           Text('我的歌单')
             .fontSize(12)
             .fontWeight(FontWeight.Medium)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 4,initialIndex:0}){

           }
         }
         .width('100%')
         .height('100%')
      }
      .scrollBar(BarState.Off)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white_background'))
  }
}