@Builder
export function SettingPageBuilder() {
  SettingPage()
}

@Component
export struct  SettingPage{
  build() {
    NavDestination(){

    }
      .title('设置')
  }
}