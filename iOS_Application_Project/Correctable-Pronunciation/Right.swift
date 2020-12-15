//
//  right.swift
//  LayoutToy
//
//  Created by 차요셉 on 06/07/2020.
//  Copyright © 2020 yoseph cha. All rights reserved.
//

import UIKit

import UIKit
class Right: UIStoryboardSegue {
    override func perform()
    {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
        },completion: { finished in
            src.present(dst, animated: false, completion: nil)
        })
    }
}

class UnwindRight: UIStoryboardSegue {
    override func perform()
    {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width/3, y: 0)
        UIView.animate(withDuration: 0, delay: 0.0, animations: {
            src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
          }, completion: { finished in
            src.dismiss(animated: false, completion: nil)
        })
    }
}
