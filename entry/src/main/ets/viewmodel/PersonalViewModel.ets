import { LoginResponse } from "../apis/api";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import ItemData, { SettingFieldType } from "./ItemData";

export class PersonalViewModel{
  private user:LoginResponse = {} as LoginResponse;

  setUser(user:LoginResponse){
    this.user = user;
  }

  getPersonalListData(): Array<Array<ItemData>> {
    let settingListData: ItemData[][] = [
      [
        new ItemData(0, '头像', SettingFieldType.AVATAR, this.user.avatar),
        new ItemData(1, '用户名', SettingFieldType.TEXT, this.user.username),
        new ItemData(2, '性别', SettingFieldType.TEXT, this.user.sex),
        new ItemData(3, '邮箱', SettingFieldType.TEXT, this.user.email),
      ],
    ];
    return settingListData;
  }
}
export default new PersonalViewModel();