import ItemData, { SettingFieldType } from "./ItemData";

export class SettingViewModel{
  getSettingListData(): Array<Array<ItemData>> {
    let settingListData: ItemData[][] = [
      [
        new ItemData(0,'个人资料',SettingFieldType.TEXT),
        new ItemData(1,'账号与安全',SettingFieldType.TEXT),
      ],
      [
        new ItemData(2, '关于',SettingFieldType.TEXT),
        new ItemData(3,'隐私设置',SettingFieldType.TEXT),
        new ItemData(4, '隐私政策管理',SettingFieldType.TEXT),
      ],
      [
        new ItemData(5, '清除缓存',SettingFieldType.TEXT),
      ],
    ];
    return settingListData;
  }
}
export default new SettingViewModel();