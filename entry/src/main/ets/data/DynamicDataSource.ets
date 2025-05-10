// 定义一个接口来表示 items 数组中的对象
export interface DynamicItemData {
  postId: string,
  userId: string,
  title:string,
  content:string,
  createdTime:string,
  updatedTime:string,
  likeCount: number,
  isDeleted: boolean,
  imageUrls:string[],
}

// 实现数据源接口
export class DynamicDataSource implements IDataSource {
  private data: DynamicItemData[] = [];
  private listeners: DataChangeListener[] = [];

  // constructor(data: DynamicItemData[]) {
  //   this.data = data;
  // }

  setDataArray(data: DynamicItemData[]):  void {
    this.data = data;
  }

  totalCount(): number {
    return this.data.length;
  }

  getData(index: number): DynamicItemData {
    return this.data[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (!this.listeners.includes(listener)) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener:  DataChangeListener): void {
    const index = this.listeners.indexOf(listener);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  notifyDataChanged(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded(); // 通知 UI 刷新数据
    });
  }

}