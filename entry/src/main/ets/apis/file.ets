import request from '../request/request'

import { FormData } from '@ohos/axios';

export async function upload<T>(formData:FormData) {
  return request<T>({
    url: '/file/upload',
    method: 'POST',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data',
    },
    onUploadProgress: (progressEvent) => {
      console.log(`上传进度: ${progressEvent.loaded} / ${progressEvent.total}`);
    },
  });
}



export function deleteFile<T>(key:string){
  return request<T>({
    url:'/file/delete',
    method:'DELETE',
    data: {key}
  })
}

export function deleteMultiple<T>(keys:string[]){
  return request<T>({
    url:'/file/deleteMultiple',
    method:'DELETE',
    data: {keys}
  })
}

export function getFileUrl<T>(key:string){
  return request<T>({
    url:'/file/getUrl',
    method:'GET',
    params: {key}
  })
}