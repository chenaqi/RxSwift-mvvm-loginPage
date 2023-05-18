//
//  JZLoginSMSRightView.swift
//  DreamVideo
//
//  Created by 陈武琦 on 2023/4/20.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

private let countDownSeconds: Int = 60
class JZLoginSMSRightView: UIView {
    
    var disposeBag = DisposeBag()
    let countDownStopped = BehaviorRelay(value: true)
    var leftTime = countDownSeconds
    let timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    
    public lazy var smsBtn = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 50))
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        
        let line = UIView()
        line.backgroundColor = .darkGray
        addSubview(line)
        addSubview(smsBtn)
        
        line.snp.makeConstraints { make in
            make.top.left.equalTo(5)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
        }
        smsBtn.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(0)
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(120)
        }
        
        countDownStopped.subscribe {[weak self] stoped in
            guard let self = self else {
                return
            }
            if stoped {
                self.smsBtn.setTitle("获取验证码", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    
    func countdownTime(){
        // 开始倒计时
        self.countDownStopped.accept(false)
        timer.take(until: countDownStopped.asObservable().filter{$0})
             .observe(on: MainScheduler.asyncInstance)
             .subscribe(onNext: { [weak self](event) in
                 guard let self = self else {
                     return
                 }
                 self.leftTime -= 1
                 /// UI操作
                 self.smsBtn.setTitle("\(self.leftTime)秒后重新获取", for: .normal)
                 if (self.leftTime == 0) {
                    print("倒计时结束")
                    self.countDownStopped.accept(true)
                    self.leftTime = countDownSeconds
                   /// UI操作
                 }
               }, onError: nil )
               .disposed(by: disposeBag)
        }



}
