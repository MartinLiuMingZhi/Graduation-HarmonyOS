import { ClassicalPage } from "../pages/home/ClassicalPage"
import { EAPage } from "../pages/home/EAPage"
import { JazzPage } from "../pages/home/JazzPage"
import { KpopPage } from "../pages/home/KpopPage"
import { NationalPage } from "../pages/home/NationalPage"
import { PopPage } from "../pages/home/PopPage"
import { RapPage } from "../pages/home/RapPage"
import { RecommendPage } from "../pages/home/RecommendPage"
import { VillagePage } from "../pages/home/VillagePage"

@Component
export struct HomePage {

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start}){
        TabContent() {
          RecommendPage()
        }.tabBar('推荐')
        TabContent() {
            NationalPage()
        }.tabBar('国风')
        TabContent() {
          EAPage()
        }.tabBar('欧美')
        TabContent() {
          RapPage()
        }.tabBar('说唱')
        TabContent() {
          KpopPage()
        }.tabBar('Kpop')
        TabContent() {
          VillagePage()
        }.tabBar('乡村')
        TabContent() {
          JazzPage()
        }.tabBar('爵士')
        TabContent(){
          PopPage()
        }.tabBar('流行')
        TabContent() {
          ClassicalPage()
        }.tabBar('古典')
      }.barMode(BarMode.Scrollable)

    }
  }
}