import { ComposeTitleBar } from "@ohos.arkui.advanced.ComposeTitleBar"

@Preview
@Component
export struct CommunityView {
  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }){
      Column(){
          ComposeTitleBar(){

          }
      }
    }
    .width('100%')
    .height('auto')
  }
}