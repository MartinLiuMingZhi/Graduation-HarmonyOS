import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig,AxiosRequestConfig } from '@ohos/axios'
import { PreferencesUtil } from '../utils/PreferencesUtil';

interface BaseResponse<T>{
  code?:string,
  msg?:string,
  data:T
}

const instance = axios.create({
  baseURL: 'http://music.liumingzhi.cn/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});


// 添加请求拦截器
instance.interceptors.request.use((config:InternalAxiosRequestConfig)=>{
  const token = PreferencesUtil.getAsync<string>('token')
  if (token) {
    config.headers['Authorization'] = 'Bearer ' + token;
  }
  return config
}, (error:AxiosError) => {
  // 对请求错误做些什么
  console.error('request error:' + error);
  return Promise.reject(error);
})

// 添加响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  return response.data
}, (error: AxiosError) => {
  if (error.response) {
    // 处理已知错误
    console.error('Response Error:', error.response.data)
  } else if (error.request) {
    // 处理请求发送失败
    console.error('Request Error:', error.request)
  } else {
    // 处理其他错误
    console.error('Error:', error.message)
  }
  return Promise.reject(error)
})


export default <T> (config:AxiosRequestConfig):Promise<BaseResponse<T>>=>{
  return instance(config)
}