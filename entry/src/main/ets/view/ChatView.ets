import { UserDTO } from "../apis/user";
import { MessageBottomComponent } from "./MessageBottomComponent";

@Builder
export function ChatViewBuilder() {
  ChatView()
}

@Component
export struct ChatView {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State userInfo: UserDTO = {
    userid: '',
    username: '',
    email: '',
    avatar: '',
    sex: ''
  };

  aboutToAppear(): void {
    const param: UserDTO[] = this.pathStack.getParamByName('ChatView') as UserDTO[];
    this.userInfo = param[0];
  }

  build() {
    NavDestination() {
      Column() {
        Scroll(){

        }

        MessageBottomComponent()
      }
    }
    .title(this.userInfo.username)
  }
}