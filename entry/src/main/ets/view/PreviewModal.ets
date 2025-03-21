// 新增预览组件
@Component
struct PreviewModal {
  @Prop title: string;
  @Prop content: string;
  @Prop images: string[];

  build() {
    Column() {

    }
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}