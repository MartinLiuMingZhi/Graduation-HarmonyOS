@Component
@Preview
export struct MIText {
  @Prop number: string;
  @Prop text: string;

  build() {
    Row({ space: 6 }) {
      Text(this.number)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)

      Text(this.text)
        .fontSize(12)
        .fontColor('#D0E2FF') // 柔和蓝灰色
    }
    .padding({ top: 6, bottom: 6, left: 10, right: 10 })
    .backgroundColor('#ff377de7')
    .borderRadius(8)
    .shadow({
      radius: 8,
      color: '#1A000000', // 更柔的阴影
      offsetX: 0,
      offsetY: 2
    })
  }
}
