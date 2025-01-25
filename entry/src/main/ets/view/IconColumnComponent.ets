@Component
export struct IconColumnComponent{

  @Prop icon: string | Resource;
  @Prop text: string;

  build() {
    Column() {
      Image(this.icon)
        .width(40)
        .height(40)
        .margin({
          bottom: 5
        })

      Text(this.text)
        .fontSize(12)
        .fontColor(Color.Black)
    }
  }
}