import UIKit

class HealthSummaryViewController: UIViewController {

    // ✅ 입력값 라벨
    @IBOutlet weak var foodSummaryLabel: UILabel!
    @IBOutlet weak var activitySummaryLabel: UILabel!
    @IBOutlet weak var conditionSummaryLabel: UILabel!
    @IBOutlet weak var sleepSummaryLabel: UILabel!

    // ✅ 목표값 라벨
    @IBOutlet weak var foodGoalLabel: UILabel!
    @IBOutlet weak var activityGoalLabel: UILabel!
    @IBOutlet weak var conditionGoalLabel: UILabel!
    @IBOutlet weak var sleepGoalLabel: UILabel!

    // ✅ 상단 제목/로고/달성률
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goalRateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✅ 로고 이미지 설정
        logoImageView.image = UIImage(named: "app_logo")
        logoImageView.contentMode = .scaleAspectFit

        // ✅ 제목 라벨 설정
        titleLabel.text = "오늘의 건강 요약"
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        // ✅ 목표 갱신 알림 수신
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSummary),
            name: Notification.Name("GoalUpdated"),
            object: nil
        )

        updateSummary()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSummary()
    }

    // ✅ 입력 요약 및 목표 요약 갱신
    @objc func updateSummary() {
        // 입력값 가져오기
        let food = Int(UserDefaults.standard.string(forKey: "inputFood") ?? "") ?? 0
        let activity = Int(UserDefaults.standard.string(forKey: "inputActivity") ?? "") ?? 0
        let condition = Int(UserDefaults.standard.string(forKey: "inputCondition") ?? "") ?? 0
        let sleep = Double(UserDefaults.standard.string(forKey: "inputSleep") ?? "") ?? 0

        // 목표값 가져오기
        let goalFood = Int(UserDefaults.standard.string(forKey: "goalFood") ?? "") ?? 0
        let goalActivity = Int(UserDefaults.standard.string(forKey: "goalActivity") ?? "") ?? 0
        let goalCondition = Int(UserDefaults.standard.string(forKey: "goalCondition") ?? "") ?? 0
        let goalSleep = Double(UserDefaults.standard.string(forKey: "goalSleep") ?? "") ?? 0

        // 입력값 표시
        foodSummaryLabel.text = "🍽️ 끼니: \(food)회"
        activitySummaryLabel.text = "🏃 운동: \(activity)분"
        conditionSummaryLabel.text = "🧠 피로도: \(condition)"
        sleepSummaryLabel.text = "🛌 수면: \(sleep)시간"

        // 목표값 표시
        foodGoalLabel.text = "🍽️: \(goalFood)회"
        activityGoalLabel.text = "🏃: \(goalActivity)분"
        conditionGoalLabel.text = "🧠: \(goalCondition)%"
        sleepGoalLabel.text = "🛌: \(goalSleep)시간"

        // 달성률 계산
        var total: Double = 0
        var achieved: Double = 0

        if goalFood > 0 {
            achieved += Double(min(food, goalFood)) / Double(goalFood)
            total += 1
        }
        if goalActivity > 0 {
            achieved += Double(min(activity, goalActivity)) / Double(goalActivity)
            total += 1
        }
        if goalCondition > 0 {
            achieved += Double(max(0, goalCondition - condition)) / Double(goalCondition)
            total += 1
        }
        if goalSleep > 0 {
            achieved += min(sleep, goalSleep) / goalSleep
            total += 1
        }

        if total > 0 {
            let percent = Int((achieved / total) * 100)
            goalRateLabel.text = "🎯 목표 달성률: \(percent)%"
        } else {
            goalRateLabel.text = "🎯 목표 미설정"
        }
    }

    // 목표 설정으로 이동
    @IBAction func goToGoalSetting(_ sender: UIButton) {
        performSegue(withIdentifier: "toGoalSetting", sender: self)
    }

    // AI 진단으로 이동
    @IBAction func goToDiagnosis(_ sender: UIButton) {
        performSegue(withIdentifier: "toDiagnosis", sender: self)
    }
}

