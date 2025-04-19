import { ISong } from "../../view/ISong"
import { SearchView } from "../../view/SearchView"
export class ListSong{
  img: string = ''
  name: string = ''
  singer: string=''
}

@Preview
@Component
export struct NationalPage{
  @State isLoading: boolean = false
  private listSong: ListSong[] = [
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000002Neh8l0uciQZ_3.jpg?max_age=2592000',
      name: '兰亭序',
      singer: '周杰伦'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000000pVkCf3KsUQ9_1.jpg?max_age=2592000',
      name: '天下',
      singer: '张杰'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000000uGdjk1J7qA2_2.jpg?max_age=2592000',
      name: '牵丝线',
      singer: '银临 /Aki阿杰'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000004NoFkr1zhODu_2.jpg?max_age=2592000',
      name: '相思遥',
      singer: '魏玉慧'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000002eFUFm2XYZ7z_3.jpg?max_age=2592000',
      name: '青花瓷',
      singer: '周杰伦'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M0000032ezFm3F53yO_3.jpg?max_age=2592000',
      name: '七里香',
      singer: '周杰伦'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T062R300x300M000000utC0R4P0aan.jpg?max_age=2592000',
      name: '夜空中最亮的星',
      singer: 'G.E.M. 邓紫棋'
    },
    {
      img: 'https://y.qq.com/music/photo_new/T002R300x300M000002x2ZoC3PH2Ug_2.jpg?max_age=2592000',
      name: '探窗',
      singer: '汐音社'
    }
  ]


  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column}){
        SearchView()
        LoadingProgress()
          .width(10)
          .height(10)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)
        Swiper(){
          Image('https://y.qq.com/music/photo_new/T002R300x300M000002TFrDN2XKDE3_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
          Image('https://y.qq.com/music/photo_new/T002R300x300M000000BjlQx3hZLst_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
          Image('https://y.qq.com/music/photo_new/T002R300x300M000003d4OAx33NwPO_1.jpg?max_age=2592000')
            .objectFit(ImageFit.Cover)
        }
        .width('100%')
        .height('30%')

        List({ space: 10,initialIndex: 0}) {
          ForEach(this.listSong, (item: ListSong) => {
            ListItem() {
              ISong({
                img: item.img,
                name: item.name,
                singer: item.singer
              })
            }
          })
        }
        .width('90%')
        .height('auto')
        .scrollBar(BarState.Off)
        .margin({
          top: 10
        })
      }
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }
}