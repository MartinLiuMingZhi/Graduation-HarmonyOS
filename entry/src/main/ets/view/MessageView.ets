import { ContactItem, getContact } from "../apis/message";
import { IconColumnComponent } from "./IconColumnComponent"
import { MessageItem } from "./MessageItem"

interface SelectItem{
  value: string;
  icon: Resource;
}

@Component
@Preview
export struct MessageView {
  @State customPopup: boolean = false
  @State selectedAction: string = '';
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State contactList: ContactItem[] = []

  // 下拉选项配置
  private dropdownOptions: SelectItem[] = [
    { value: '添加好友', icon: $r('app.media.ic_add_friend') },
    { value: '创建群聊', icon: $r('app.media.ic_create_groupchat') },
    { value: '扫一扫', icon: $r('app.media.ic_scan') },
  ]

  // popup构造器定义弹框内容
  // 优化后的气泡构建器
  @Builder
  popupBuilder() {
    Column() {
      ForEach(this.dropdownOptions, (item: SelectItem,index:number) => {
        Row() {
          Image(item.icon)
            .width(20)
            .height(20)
            .margin({ right: 8})
          Text(item.value)
            .fontSize(14)
            .fontColor(Color.Black)
        }
        .width(120)
        .height(40)
        .padding(8)
        .onClick(() => {
          this.customPopup = false;
          this.handleSelect(item.value)
        })
        //分隔线
        if (index < this.dropdownOptions.length -1) {
          Divider()
            .width(110)
            .margin({ top: 4, bottom: 4 })
        }
      })
    }
    .padding(8)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .shadow({ radius: 8, color: '#1F000000', offsetX: 2, offsetY: 2 })
  }

  aboutToAppear(): void {
    this.getContactList()
  }

  private async getContactList(){
    const result = await getContact<ContactItem[]>()
    if(result.code === '200'){
      this.contactList = result.data
    }else {
      console.error('获取联系人列表失败:', JSON.stringify(result.msg))
    }
  }

  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_btn_add'))
          .width(24)
          .height(24)
          .alignSelf(ItemAlign.Center) // 修改对齐方式为居中
          .onClick(() => {
            this.customPopup  = !this.customPopup
          })
          .bindPopup(this.customPopup,{
            builder: this.popupBuilder(),
            placement: Placement.Bottom,
            mask: true,
            onStateChange:(e)=>{
              if(!e.isVisible){
                this.customPopup = false
              }
            },
          })


        Text('消息')
          .fontSize(16)
          .fontColor('#000000') // 修改字体颜色为黑色
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_search'))
          .width(24)
          .height(24)
          .alignSelf(ItemAlign.Center) // 修改对齐方式为居中
          .onClick(() => {

          })

      }
      .width('100%')
      .height(48)
      .backgroundColor('#FFFFFF') // 修改背景颜色为白色或其他需要的颜色
      .padding({
        left: 10,
        right: 10
      })
      // 添加背景图片（假设图片资源为'app.media.bg_image'）
      .borderRadius(8) // 添加圆角

      Scroll(){
        Column(){
          Row() {
            IconColumnComponent({
              icon:$r('app.media.ic_like_favorite'),
              text:'赞和收藏'
            })

            IconColumnComponent({
              icon:$r('app.media.ic_new_friend'),
              text:'新朋友'
            })

            IconColumnComponent({
              icon:$r('app.media.ic_comment'),
              text:'评论和@'
            })
          }
          .width('100%')
          .height('auto')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: 30,
            right:30
          })

          ForEach(this.contactList, (item: ContactItem) => {
            MessageItem({item: item})
          })

        }
        .width('100%')
        .height('100%')


      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('auto')
      .backgroundColor(Color.White)

    }
  }

  // 处理选择事件
  private handleSelect(value: string) {
    this.selectedAction = value;
    // 根据选择执行不同操作
    switch (value) {
      case '添加好友':
        // 跳转到添加好友页面
        this.pathStack.pushPathByName('AddFriendView',null)
        break;
      case '创建群聊':
        this.pathStack.pushPathByName('CreateGroupChatView',null)
        // 跳转到创建群聊页面
        break;
      case '扫一扫':
        // 调用扫码功能
        this.pathStack.pushPathByName('ScanBarCodePage',null)
        break;
    }
  }
}