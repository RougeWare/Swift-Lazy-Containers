Pod::Spec.new do |s|
    s.name         = "LazyContainers"
    s.version      = "4.0.0"
    s.summary      = "A few ways to have a lazily-initialized value in Swift 5.1"
    s.homepage     = "https://github.com/RougeWare/Swift-Lazy-Containers.git"
    s.license      = {:type => "multiple", :file => "LICENSE.txt" }
    s.author             = { "Ben Leggiero" => "BenLeggiero@Gmail.com" }
    s.ios.deployment_target = "9.0"
    s.osx.deployment_target = "10.10"
    s.watchos.deployment_target = "2.0"
    s.tvos.deployment_target = "9.0"
    s.source       = { :git => "https://github.com/RougeWare/Swift-Lazy-Containers.git", :tag => s.version.to_s }
    s.source_files = 'Sources/LazyContainers/**/*.swift'
    s.frameworks  = "Foundation"
    s.swift_versions = ['5.1', '5.2']
  end
