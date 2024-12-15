
export class MediaService{
  private static instance: MediaService;
  private constructor() {

  }
  public static getInstance(): MediaService {
    let mediaService: MediaService | undefined = AppStorage.get('mediaService');
    if (!mediaService) {
      mediaService = new MediaService();
      AppStorage.setOrCreate('mediaService', mediaService);
    }
    return mediaService;
  }


}