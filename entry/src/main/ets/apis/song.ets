import request from '../request/request'

export function getSongById<T>(id:number){
  return request<T>({
    url:'/song',
    method:'GET',
    params:{id}
  })
}

export interface Song{
  id: number,
  title: string,
  singer: string,
  mark: string,
  label: string,
  src: string,
  index: number,
  lyric: string
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

