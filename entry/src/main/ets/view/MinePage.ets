import { CardView } from "./CardView"

@Entry
@Component
export struct MinePage {

  build() {
    Column(){
      Search({placeholder:'搜索你想要找的音乐'})
        .width('95%')

      Scroll(){
        CardView()
      }

    }
    .width('100%')
    .height('100%')
  }
}