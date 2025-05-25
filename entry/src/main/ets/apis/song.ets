import request from '../request/request'

export function getSongById<T>(id:number){
  return request<T>({
    url:'/song',
    method:'GET',
    params:{id}
  })
}

export function getSongList<T>(){
  return request<T>({
    url:'/song/list',
    method:'GET'
  })
}

export function getSongByName<T>(name:string){
  return request<T>({
    url:'/song/listByName',
    method:'GET',
    params:{name}
  })
}

export interface SongDTO{
   songId:number
   title:string
   singer:string
   genre:string
   duration:string
   releaseDate:string
   url:string
   imageUrl:string
   description:string
   songLrc:string
}

export function getSongListByGenre<T>(genre:string,page:number,pageSize:number){
  return request<T>({
    url:'/song/listByGenre',
    method:'GET',
    params:{genre,page,pageSize}
  })
}

export function getRandomSong<T>(page:number,pageSize:number){
  return request<T>({
    url:'/song/random',
    method:'GET',
    params:{page,pageSize}
  })
}

