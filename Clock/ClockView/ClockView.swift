//
//  ClockView.swift
//  Clock
//
//  Created by yubin.zhu on 2019/11/8.
//  Copyright © 2019 ford. All rights reserved.
//


import UIKit

/// 每个数字指针的组件
class ComponentView: UIView {

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .timeColor
        label.backgroundColor = .randomColor
        label.font = UIFont.timeFont
        label.isUserInteractionEnabled = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        timeLabel.frame = CGRect(x: bounds.width - 30, y: 0, width: 30, height: bounds.height)
        addSubview(timeLabel)
    }
}


/// 每一圈轮盘的视图（月，日，时，分，秒）
class TimeView: UIView {

    let unit: String
    let start: Int
    let end: Int

    init(frame: CGRect, unit: String, start: Int, end: Int) {
        self.unit = unit
        self.start = start
        self.end = end
        super.init(frame: frame)
        drawTime()
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawTime() {
        for index in start...end {
            let component = ComponentView(frame: CGRect(x: center.x, y: center.y, width: bounds.width / 2, height: 30))
            component.timeLabel.text = String(format: "%0.2ld\(unit)", index)
            addSubview(component)
            component.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            component.layer.position = center
            let angle = -CGFloat.pi * 2 * CGFloat(index) / CGFloat(end - start + 1)
            component.transform = component.transform.rotated(by: angle)
        }
    }
}


/// 轮盘时钟视图
class ClockView: UIView {

    lazy var offset: CGFloat = {
        return bounds.width / 6
    }()

    /// 秒
    lazy var secondView: UIView = {
        let view = TimeView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width), unit: "秒", start: 0, end: 59)
        view.center = center
        return view
    }()

    /// 分
    lazy var minuteView: UIView = {
        let view = TimeView(frame: CGRect(x: 0, y: 0, width: bounds.width - offset, height: bounds.width - offset), unit: "分", start: 0, end: 59)
        view.center = center
        return view
    }()
    
    /// 时
    lazy var hourView: UIView = {
        let view = TimeView(frame: CGRect(x: 0, y: 0, width: bounds.width - offset * 2, height: bounds.width - offset * 2), unit: "时", start: 0, end: 23)
        view.center = center
        return view
    }()

    /// 日
    lazy var dayView: UIView = {
        let view = TimeView(frame: CGRect(x: 0, y: 0, width: bounds.width - offset * 3, height: bounds.width - offset * 3), unit: "日", start: 1, end: Date().monthLength)
        view.center = center
        return view
    }()

    /// 月
    lazy var monthView: UIView = {
        let view = TimeView(frame: CGRect(x: 0, y: 0, width: bounds.width - offset * 4, height: bounds.width - offset * 4), unit: "月", start: 1, end: 12)
        view.center = center
        return view
    }()

    /// 年
    lazy var yearLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.center = center
        label.textColor = .timeColor
        label.textAlignment = .center
        label.backgroundColor = .randomColor
        label.font = UIFont.timeFont
        return label
    }()
    
    var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTick), userInfo: nil, repeats: true)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addSubview(secondView)
        addSubview(minuteView)
        addSubview(hourView)
        addSubview(dayView)
        addSubview(monthView)
        addSubview(yearLabel)
    }

    @objc func handleTick() {
        let date = Date()
        // 普通动画
//        UIView.animate(withDuration: 1) {
//            self.secondView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.second.intValue + 1) / 60)
//            self.minuteView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.minute.intValue) / 60)
//            self.hourView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.hour.intValue) / 24)
//            self.dayView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.day.intValue) / CGFloat(date.monthLength))
//            self.monthView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.month.intValue) / 12)
//            self.yearLabel.text = "\(date.year)年"
//        }
        
        // 弹簧动画
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.secondView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.second.intValue + 1) / 60)
            self.minuteView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.minute.intValue) / 60)
            self.hourView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.hour.intValue) / 24)
            self.dayView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.day.intValue) / CGFloat(date.monthLength))
            self.monthView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 2 * CGFloat(date.month.intValue) / 12)
            self.yearLabel.text = "\(date.year)年"
        }, completion: nil)
        
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}

/// 日期的扩展
public extension Date {

    /// 获取当前月的所有天数
    var monthLength: Int {
        let calendar = Calendar.current
        let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date())
        return range?.count ?? 30
    }

    /// 获取当前时间的年份
    var year: String {
        return string(from:"YYYY")
    }

    /// 获取当前时间的月份
    var month: String {
        return string(from: "MM")
    }

    /// 获取当前时间的所在日
    var day: String {
        return string(from: "dd")
    }

    /// 获取当前时间的小时
    var hour: String {
        return string(from: "HH")
    }

    /// 获取当前时间的分钟
    var minute: String {
        return string(from: "mm")
    }

    /// 获取当前时间的秒
    var second: String {
        return string(from: "ss")
    }

    private func string(from format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

/// 字符串的扩展
public extension String {
    var intValue: Int {
        return Int(self) ?? 0
    }
}

/// 字体扩展
public extension UIFont {
    static var timeFont: UIFont {
        return UIFont.systemFont(ofSize: 10)
    }
}

/// 颜色扩展
public extension UIColor {
    static var randomColor: UIColor {
        let red = CGFloat.random(in: 0.0...1.0)
        let green = CGFloat.random(in: 0.0...1.0)
        let blue = CGFloat.random(in: 0.0...1.0)
        let alpha = CGFloat.random(in: 0.0...0.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var timeColor: UIColor {
        return white
    }
}




