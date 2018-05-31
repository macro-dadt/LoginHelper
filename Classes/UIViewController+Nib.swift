//
//  UIViewController+Nib.swift
//  Pods
//
//  Created by DT Dat on 2018/5/27.
//
//

import Foundation

public extension UIViewController {

	func viewFromNib(optionalName: String? = nil) -> UIView {
		let name = optionalName ?? String(describing: type(of: self))
        let bundle = Bundle(for: LoginCoordinator.self)
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }
    
}
