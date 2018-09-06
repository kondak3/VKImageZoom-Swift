# VKImageZoom

## Requirements:

- iOS 8 or higher

- Swift 3 or higher


## Usage:

- Drag and drop "VKImageZoom" folder into your resource

```
// if you have image use this below one...
let zoomCtrl = VKImageZoom()
zoomCtrl.image = UIImage.init(named: "your image name")
self.present(zoomCtrl, animated: true, completion: nil)
```

```
// if you have image url use this below one...
let zoomCtrl = VKImageZoom()
zoomCtrl.image_url = URL.init(string: "your image url")
self.present(zoomCtrl, animated: true, completion: nil)
```
