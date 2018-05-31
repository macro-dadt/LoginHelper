//
//  RecoverCodeViewController.swift
//
//
//  Created by Do Thanh Dat on 2018/05/28.
//

import UIKit
protocol RecoverCodeViewControllerDelegate {
    func didSelectLoginAfterChangePassWord(_ viewController: UIViewController,_ email: String, _ password: String, _ recoveryCode: String)
    func recoveryDidSelectBack(_ viewController: UIViewController)
}
class RecoverCodeViewController: UIViewController {
    @IBOutlet weak var codeLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassWordLabel: SkyFloatingLabelTextField!
    
    @IBOutlet weak var loginButton: Buttn!
     var selectedField: UITextField?
    var delegate:RecoverCodeViewControllerDelegate?
    public var email:String? = nil
    override func viewDidLoad() {
       self.view = viewFromNib(optionalName: "RecoverCodeViewCotroller")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didLoginAfterChangePassWord(_ sender: Any) {
        guard let passWord = newPassWordLabel.text, let code = codeLabel.text else {
            return
        }
        delegate?.didSelectLoginAfterChangePassWord(self,email!,passWord, code)
    }
    @IBAction func didSelectBack(_ sender: Any) {
        delegate?.recoveryDidSelectBack(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RecoverCodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedField = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
         let nextTag = textField.tag + 1
        let nextResponder = view.viewWithTag(nextTag) as UIResponder!
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            didSelectBack(self)
        }
        
        return false
    }
}
