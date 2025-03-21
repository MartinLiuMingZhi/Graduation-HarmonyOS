// 定义一个接口来表示 items 数组中的对象
export interface DynamicItemData {
  dynamic_title: string;
  dynamic_img: string;
  dynamic_avatar: string;
  dynamic_name: string;
  dynamic_likes: string;
  dynamic_like_state: boolean;
}

// 实现数据源接口
export class DynamicDataSource implements IDataSource {
  private data: DynamicItemData[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(data: DynamicItemData[]) {
    this.data = data;
  }

  totalCount(): number {
    return this.data.length;
  }

  getData(index: number): DynamicItemData {
    return this.data[index];
  }

  registerDataChangeListener(_: DataChangeListener): void {}

  unregisterDataChangeListener(): void {}
}