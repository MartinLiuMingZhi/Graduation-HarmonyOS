export class SongItem {
  /**
   * Primary key ID.
   */
  id: number = 0;

  /**
   * Music name.
   */
  title: string = '';

  /**
   * Music author name.
   */
  singer: string = '';

  /**
   * Music logo information.
   */
  mark: string = '';

  /**
   * Music avatar information.
   */
  label: string = '';

  /**
   * Music file path information.
   */
  src: string = '';

  /**
   * Index of the current music list.
   */
  index: number = 0;

  /**
   * Lyric file path information.
   */
  lyric: string = '';
}
