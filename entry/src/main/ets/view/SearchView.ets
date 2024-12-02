@Entry
@Component
export struct SearchView {

  build() {
    Column(){
      Search({placeholder:'搜索你想要找的音乐'})
        .width('95%')
        .placeholderFont({
          size: 14,
        })
    }
    .width('100%')
  }
}