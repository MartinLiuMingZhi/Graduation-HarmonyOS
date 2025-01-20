import { common } from "@kit.AbilityKit";
import { Logger } from "./Logger";
import { SongItem } from "../data/SongData";

export default class SongItemBuilder {
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private songItem: SongItem | null = null;

  public async build(songItem: SongItem): Promise<SongItem> {
    this.songItem = songItem;
    Logger.info('SongItemBuilder build src:' + this.songItem.src);
    return this.songItem;
  }

  public getRealUrl(): string | undefined {
    Logger.info(`url ${this.songItem?.src}`);
    return this.songItem?.src;
  }


  public async release(): Promise<void> {
    this.songItem = null;
  }
}