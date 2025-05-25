// 新建 data/SongRepository.ets
import { Page } from "../apis/BaseResponse";
import { getRandomSong, getSongList } from "../apis/song";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import { SongItem } from "./SongData";

export class SongRepository {
  private static INSTANCE: SongRepository;

  // 本地歌单存储键
  private readonly LOCAL_PLAYLIST_KEY = 'songList';

  // 网络歌单
  async fetchOnlineSongs(): Promise<SongItem[]> {
    const response = await getRandomSong<Page<SongItem[]>>(1,10);
    console.log('fetchOnlineSongs', JSON.stringify(response.data.records))
    return response.data.records || [];
  }

  // 获取所有歌曲（优先本地，再网络）
  async getSongs(): Promise<SongItem[]> {
    const localSongs = await this.getLocalSongs();
    if (localSongs.length > 0) return localSongs;

    const onlineSongs = await this.fetchOnlineSongs();
    await this.saveLocalSongs(onlineSongs); // 缓存网络歌曲
    return onlineSongs;
  }

  // 保存本地歌单
  async saveLocalSongs(songs: SongItem[]): Promise<void> {
    await PreferencesUtil.putAsync(this.LOCAL_PLAYLIST_KEY, JSON.stringify(songs));
  }

  // 获取本地歌单
  async getLocalSongs(): Promise<SongItem[]> {
    const data = await PreferencesUtil.getAsync<string>(this.LOCAL_PLAYLIST_KEY);
    console.log('getLocalSongs', JSON.stringify(data))
    return data ? JSON.parse(data) : [];
  }

  // 添加歌曲到本地歌单
  async addSongToLocal(song: SongItem): Promise<void> {
    const songs = await this.getLocalSongs();
    songs.push(song);
    await this.saveLocalSongs(songs);
  }

  // 从本地歌单移除歌曲
  async removeSongFromLocal(index: number): Promise<void> {
    const songs = await this.getLocalSongs();
    songs.splice(index, 1);
    await this.saveLocalSongs(songs);
  }

  static getInstance(): SongRepository {
    if (!SongRepository.INSTANCE) {
      SongRepository.INSTANCE = new SongRepository();
    }
    return SongRepository.INSTANCE;
  }
}