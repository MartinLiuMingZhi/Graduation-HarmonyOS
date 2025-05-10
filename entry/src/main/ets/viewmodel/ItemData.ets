export default class ItemData{
  id: number;
  title: string;
  others?: Resource

  constructor(id: number, title: string, others?: Resource) {
    this.id = id;
    this.title = title;
    this.others = others;
  }
}