//
//  JZLoginViewController.swift
//  DreamVideo
//
//  Created by 陈武琦 on 2023/4/20.
//

import UIKit
import SnapKit
import RxSwift
import MBProgressHUD
import UILabelImageText
import RxCocoa

class JZLoginViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var smsCodeTextField: UITextField!
    @IBOutlet weak var agreeL: UILabel!
    private lazy var smsRightView: JZLoginSMSRightView = {
        let rightView = JZLoginSMSRightView()
        return rightView
    }()
    var disposeBag = DisposeBag()
    let agreementSelected = BehaviorSubject<Bool>(value: false)
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        title = "登录"
        
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        smsCodeTextField.rightView = smsRightView
        smsCodeTextField.rightViewMode = .always;
        
        setupAgreement()
        bindViewModel()
    }
    
    
    func setupAgreement() {
        
        agreeL.imageText(normalImage: UIImage(named: "common_icon_unselected"), selectedImage: UIImage(named: "common_icon_selected"), content: " 我已阅读并同意《用户协议》和《隐私协议》", font: UIFont.systemFont(ofSize: 12), largeFont: UIFont.systemFont(ofSize: 20), alignment: .left)
        agreeL.setImageCallBack {[weak self] in
            Toast("点击图标")
            self?.agreementSelected.onNext(self?.agreeL.selected ?? false)
        }
        
        agreeL.setSubstringCallBack(substring: "《用户协议》", color: .gray) {
            Toast("点击《用户协议》")
        }
        
        agreeL.setSubstringCallBack(substring: "《隐私协议》", color: .gray) {
            Toast("点击《隐私协议》")
        }
    }
}

/// 绑定ViewModel
extension JZLoginViewController {
    
    func bindViewModel() {
        let phoneObservable = phoneTextField.rx.text.orEmpty.asObservable()
        let smsObservable = smsCodeTextField.rx.text.orEmpty.asObservable()
        let smsCountDownObservable = smsRightView.countDownStopped.asObservable()
        let checkBoxObservable = agreementSelected.asObservable()
        
        let viewModel = JZLoginViewModel(phone: phoneObservable,
                                         smsCode: smsObservable,
                                         smsCountDown: smsCountDownObservable,
                                         checkBox: checkBoxObservable,
                                         disposeBag:disposeBag)
        //控制手机号长度
        viewModel.phoneTextMaxLengthObservable
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        //控制验证码长度
        viewModel.smsTextMaxLengthObservable
            .bind(to: smsCodeTextField.rx.text)
            .disposed(by: disposeBag)
                
        //控制按钮是否可点击
        viewModel.smsBtnEnableObservable
            .bind(to: smsRightView.smsBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //订阅按钮点击
        smsRightView.smsBtn.rx.tap
            .withLatestFrom(agreementSelected.asObservable())
            .subscribe {[weak self] checked in
            guard let self = self else {
                return
            }
            if checked {
                self.sendSMSCode()
                self.smsRightView.countdownTime()
            }else {
               Toast("请阅读并同意协议")
            }
        }.disposed(by: disposeBag)
        
        //订阅登录
        viewModel.everyThingValidObservable.subscribe {[weak self] valid in
            if valid {
                self?.login()
            }
        }.disposed(by: disposeBag)
    }
}

/// 网络请求
extension JZLoginViewController {
    
    func login() {
        guard let phone = phoneTextField.text, let sms = smsCodeTextField.text else {return}
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            print("phone:" + phone + " sms:" + sms)
            hud.label.text = "登录成功"
            hud.hide(animated: true, afterDelay: 1)
        }
    }
    

    func sendSMSCode() {
        print("调用发送验证码接口")
    }
    
}
