export enum SettingFieldType {
  AVATAR,   // 头像
  TEXT,     // 文本
  SWITCH,   // 开关
  BUTTON    // 按钮
}


export default class ItemData {
  id: number;
  title: string;
  fieldType: SettingFieldType; // 字段类型
  value?: string | Resource;   // 根据类型传入字符串或资源路径
  others?: Resource;

  constructor(id: number, title: string, fieldType: SettingFieldType, value?: string | Resource, others?: Resource) {
    this.id = id;
    this.title = title;
    this.fieldType = fieldType;
    this.value = value;
    this.others = others;
  }
}