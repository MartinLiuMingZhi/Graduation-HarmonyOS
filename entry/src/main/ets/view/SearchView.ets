@Entry
@Component
export struct SearchView {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack()

  build() {
    Column(){
      Search({placeholder:'搜索你想要找的音乐'})
        .width('95%')
        .placeholderFont({
          size: 14,
        })
        .enableKeyboardOnFocus(false)
        .focusable(false)
        .onClick(()=>{
          this.pathStack.pushPathByName('MusicSearchPage',null)
        })
    }
    .width('100%')
  }
}