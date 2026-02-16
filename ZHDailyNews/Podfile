platform :ios, '11.0'
use_frameworks!

target 'ZhihuDailyNews1' do
  pod 'AFNetworking'
  pod 'YYModel'
  pod 'SDWebImage'
  pod 'Masonry'
  pod 'MJRefresh'
  pod 'SDCycleScrollView'
  pod 'Ono'
  pod 'MBProgressHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 统一提升第三方库的最低部署目标，解决 libarclite 报错
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end