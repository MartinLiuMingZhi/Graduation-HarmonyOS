import ItemData from "./ItemData";

export class SettingViewModel{
  getSettingListData(): Array<Array<ItemData>> {
    let settingListData: ItemData[][] = [
      [
        new ItemData(0,'个人资料'),
        new ItemData(1,'账号与安全'),
      ],
      [
        new ItemData(2, '关于'),
        new ItemData(3,'隐私设置'),
        new ItemData(4, '隐私政策管理'),
      ],
      [
        new ItemData(5, '清除缓存'),
      ],
    ];
    return settingListData;
  }
}
export default new SettingViewModel();