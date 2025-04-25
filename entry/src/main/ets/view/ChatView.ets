import { UserDTO } from "../apis/user";

@Builder
export function ChatViewBuilder() {
  ChatView()
}

@Component
export struct ChatView {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State title: string = '';

  aboutToAppear(): void {
     this.pathStack.getParamByName('ChatView')

  }

  build() {
    NavDestination() {
      Column() {

      }
    }

  }
}