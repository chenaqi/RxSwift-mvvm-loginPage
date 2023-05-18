//
//  Toast.swift
//  DreamVideo
//
//  Created by Jang on 2023/4/24.
//

import UIKit
import Toast_Swift

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height

/// Toast文本
/// - Parameters:
///   - message: 消息
///   - isOnlyDebug: 是否区分debug环境弹出
public func Toast(_ message:String,_ isOnlyDebug:Bool = false,_ duration:TimeInterval = 1.0) {
    if isOnlyDebug == true {
        #if DEBUG
        Toast(message, duration)
        #endif
    } else {
        Toast(message, duration)
    }
}

public func Toast_hide() {
    guard let window = frontWindow() else { return }
    window.hideToast()
}


private func Toast(_ message:String,_ duration:TimeInterval = 1.0) {
    guard let window = frontWindow() else { return }
    let p = CGPoint.init(x: ScreenWidth / 2.0, y: ScreenHeight / 2.0)
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        guard let window = frontWindow() else { return }
        let p = CGPoint.init(x: ScreenWidth / 2.0, y: ScreenHeight / 2.0)
        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        window.makeToast(message, duration:duration, point: p, title: nil, image: nil) { didTap in
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        }
    }
}

public func Loading(_ position:ToastPosition = .center) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        guard let window = frontWindow() else { return }
        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        window.makeToastActivity(position)
    }
}

public func HiddenLoading() {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        guard let window = frontWindow() else { return }
        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        window.hideToastActivity()
    }

}



fileprivate func frontWindow() -> UIWindow? {
    let frontToBackWindows = UIApplication.shared.windows.reversed()
    return frontToBackWindows.first { window in
        let windowOnMainScreen = window.screen == UIScreen.main
        let windowIsVisible = !window.isHidden && window.alpha > 0
        let windowKeyWindow = window.isKeyWindow
        if windowOnMainScreen && windowIsVisible && windowKeyWindow {
            return true
        }
        return false
    }
}
