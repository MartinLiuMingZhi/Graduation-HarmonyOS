@Component
export struct MIText{
  @Prop number: string  ;
  @Prop text: string;

  build() {
    Row({space:5}) {
     Text(this.number)
       .fontSize(13)
       .fontColor(Color.White)

     Text(this.text)
       .fontSize(12)
       .fontColor(Color.Gray)
    }
    .padding(5)
    .backgroundColor('#330b6ee3')
    .shadow(10)
    .borderRadius(5)
  }
}
