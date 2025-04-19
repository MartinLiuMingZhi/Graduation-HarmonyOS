@Builder
export function CreateGroupChatViewBuilder() {
  CreateGroupChatView()
}

@Component
export struct CreateGroupChatView{
  build() {
    NavDestination(){
      Text('创建群聊')
    }
  }
}