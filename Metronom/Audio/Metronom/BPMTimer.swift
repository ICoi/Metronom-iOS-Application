//
//  BPMTimer.swift
//  Metronom
//
//  Created by 정다운 on 8/11/24.
//

import RxSwift
import UIKit

class BPMTimer: NSObject {
    private var timer: Timer?
    private var interval: TimeInterval = 0
    private var bpm: Int = 0
    
    private let tickSubject: PublishSubject<Bool> = PublishSubject()
    
    override init() {
    }
    
    func start(bpm: Int) {
        self.bpm = bpm
        self.interval = 60.0 / Double(bpm) // 1분(60초) / BPM
        
        timer?.invalidate() // 기존 타이머를 무효화
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func observe() -> Observable<Bool> {
        return tickSubject.asObservable()
    }
    
    @objc
    private func tick() {
        print("Tick")
        // 여기에 알림음을 재생하거나 필요한 작업을 추가합니다.
        tickSubject.onNext(true)
    }
}
