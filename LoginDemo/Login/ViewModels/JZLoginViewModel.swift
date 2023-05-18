//
//  JZLoginViewModel.swift
//  DreamVideo
//
//  Created by 陈武琦 on 2023/4/26.
//

import Foundation
import RxSwift

//手机号长度
let phoneMaxLength = 11
//验证码长度
let smsMaxLength = 4

class JZLoginViewModel {
    

    //手机号长度限制序列
    let phoneTextMaxLengthObservable: Observable<String>
    //验证码长度限制序列
    let smsTextMaxLengthObservable: Observable<String>
    
    //验证码按钮是否可用序列
    let smsBtnEnableObservable: Observable<Bool>
    //一切准备好序列
    let everyThingValidObservable: Observable<Bool>
    
    init(
        phone: Observable<String>,
        smsCode: Observable<String>,
        smsCountDown: Observable<Bool>,
        checkBox:Observable<Bool>,
        disposeBag:DisposeBag) {
            
            //手机号是否有效
            let phoneVaild = phone.map {
                let regex = "^1[3456789]\\d{9}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: $0) && $0.count == phoneMaxLength
            }.distinctUntilChanged().share(replay: 1)
            
            
            //验证码是否有效
            let smsValid = smsCode.map {
                let regex = "^\\d{4}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: $0) && $0.count == smsMaxLength
            }.distinctUntilChanged().share(replay: 1)
            
            //手机号长度限制
            phoneTextMaxLengthObservable = phone.map({ phoneNumber in
                return String(phoneNumber.prefix(11))
            })
            
            
            //验证码长度限制
            smsTextMaxLengthObservable = smsCode.map({ phoneNumber in
                return String(phoneNumber.prefix(4))
            })
            
            //验证码按钮可点击控制
            smsBtnEnableObservable = Observable.combineLatest(phoneVaild, smsCountDown).map({
                $0 && $1
            }).share(replay: 1)
            
            everyThingValidObservable = Observable.combineLatest(phoneVaild, smsValid, checkBox).map {$0 && $1 && $2}
            
        }
}
