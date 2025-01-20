import { resourceManager } from '@kit.LocalizationKit';
import { SongItem } from './SongData';

/**
 * Card data.
 */
export class CardData {
  /**
   * The music is playing.
   */
  isPlay?: boolean;

  /**
   * The music name.
   */
  musicName?: string;

  /**
   * The music cover.
   */
  musicCover?: string;

  /**
   * The music singer.
   */
  musicSinger?: string;

  /**
   * The song list.
   */
  cardSongList?: SongItem[];
}