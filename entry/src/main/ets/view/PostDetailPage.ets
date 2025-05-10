@Builder
export function PostDetailPageBuilder(){
  PostDetailPageBuilder()
}

@Preview
@Component
export struct PostDetailPage {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State avatar: string = ''
  @State username: string = ''

  aboutToAppear(): void {
    console.log('PostDetailPage aboutToAppear');
  }

  build() {
    NavDestination(){

    }
    .title(this.TitleBuilder())
  }

  @Builder
  TitleBuilder(){
    Row(){
      Image(this.avatar)
        .width(30)
        .height(30)
        .borderRadius(15)
        .margin({left: 10})

      Text(this.username)
        .fontSize(16)
        .margin({left: 10})
    }
    .width('100%')
    .margin({top: 10})
  }
}