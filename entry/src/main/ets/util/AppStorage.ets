export default class AppStorage {
  private static instance: AppStorage;
  private context: Context | null = null; // 初始化为 null

  private constructor() {}

  static getInstance(): AppStorage {
    if (!AppStorage.instance) {
      AppStorage.instance = new AppStorage();
    }
    return AppStorage.instance;
  }

  setContext(context: Context) {
    this.context = context;
  }

  getContext(): Context | null {
    return this.context;
  }
}

