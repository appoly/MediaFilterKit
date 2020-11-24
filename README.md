# MediaFilterKit
A swift library for wrapping and applying core image filters to a image or audiovisual asset.
 
**Installing with cocoapods**
```
pod 'MediaFilterKit'
```

**Quick start**
Start by importing the library into your file
```
import MediaFilterKit
```

You can create a `MFKImage` object and asynchronously apply filters. 
```
let image = MFKImage(uiImage: UIImage(named: "image")!)
image.applying(filters: [.chrome]) { self.imageView.image = $0 }
```

You can create an `MFKAsset` object, this object allows you access to the asset's placeholder image (which is a screenshot of the first frame in the video).
```
let mkAsset = MFKAsset(url: URL(string: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"))
imageView.image = asset.placeholder
```
OR
```
let asset = AVAsset(url: URL(string: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"))
let mkAsset = MFKAsset(asset: asset)
imageView.image = mkAsset.placeholder
```

You can also asynchronously apply filters to an `MFKAsset`.
```
let player: AVPlayer?
mkAsset.applying(filters: [.chrome], with: .presetHighestQuality { 
    player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
    player.play()
}
```
