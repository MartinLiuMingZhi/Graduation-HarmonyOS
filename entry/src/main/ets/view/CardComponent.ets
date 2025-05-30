interface Item{
  label: string;
  value: string;
}

@Component
export struct CardComponent {
  title: string = ''
  content?: string
  items?: Array<Item>
  showDivider: boolean = false

  build() {
    Column({ space: 12 }) {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16 })

      if (this.content !== undefined) {
        Text(this.content)
          .fontSize(14)
          .fontColor('#555')
          .margin({ left: 16, right: 16 })
      }

      if (this.items && this.items.length > 0) {
        List({ space: 10 }) {
          ForEach(this.items, (item:Item) => {
            ListItem() {
              Row() {
                Text(item.label)
                  .fontSize(16)
                  .width('40%')
                  .margin({ left: 16 })
                Text(item.value)
                  .fontSize(16)
                  .fontColor('#333')
              }
            }
            .height(40)
          }, (item:Item) => item.label)
        }
        .width('100%')
        .padding({ left: 10, right: 10 })
      }

      if (this.showDivider) {
        Divider()
          .strokeWidth(1)
          .color('#EEE')
          .margin({ top: 10, bottom: 10 })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .padding({ top: 12, bottom: 12 })
    .margin({ left: 16, right: 16 })
  }
}
