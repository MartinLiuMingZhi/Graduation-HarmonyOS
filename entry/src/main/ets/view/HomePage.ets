import { NationalPage } from "../pages/home/NationalPage"

@Component
export struct HomePage {

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start}){
        TabContent() {

        }.tabBar('推荐')
        TabContent() {
            NationalPage()
        }.tabBar('国风')
        TabContent() {

        }.tabBar('欧美')
        TabContent() {

        }.tabBar('说唱')
        TabContent() {

        }.tabBar('Kpop')
        TabContent() {

        }.tabBar('乡村')
        TabContent() {

        }.tabBar('爵士')
        TabContent() {

        }.tabBar('古典')
      }.barMode(BarMode.Scrollable)

    }
  }
}