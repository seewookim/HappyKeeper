import UIKit

class GoalSettingViewController: UIViewController {

    @IBOutlet weak var foodGoalTextField: UITextField!
    @IBOutlet weak var activityGoalTextField: UITextField!
    @IBOutlet weak var conditionGoalTextField: UITextField!
    @IBOutlet weak var sleepGoalTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✅ 숫자 키패드 설정
        foodGoalTextField.keyboardType = .numberPad
        activityGoalTextField.keyboardType = .numberPad
        conditionGoalTextField.keyboardType = .numberPad
        sleepGoalTextField.keyboardType = .decimalPad

        // ✅ 기존 값 불러오기 (있다면)
        foodGoalTextField.text = UserDefaults.standard.string(forKey: "goalFood")
        activityGoalTextField.text = UserDefaults.standard.string(forKey: "goalActivity")
        conditionGoalTextField.text = UserDefaults.standard.string(forKey: "goalCondition")
        sleepGoalTextField.text = UserDefaults.standard.string(forKey: "goalSleep")
    }

    // ✅ 저장 버튼 클릭 시 실행
    @IBAction func saveGoalButtonTapped(_ sender: UIButton) {
        // 🔢 텍스트 필드 값 가져오기
        let foodGoal = foodGoalTextField.text ?? ""
        let activityGoal = activityGoalTextField.text ?? ""
        let conditionGoal = conditionGoalTextField.text ?? ""
        let sleepGoal = sleepGoalTextField.text ?? ""

        // ✅ UserDefaults에 저장
        UserDefaults.standard.set(foodGoal, forKey: "goalFood")
        UserDefaults.standard.set(activityGoal, forKey: "goalActivity")
        UserDefaults.standard.set(conditionGoal, forKey: "goalCondition")
        UserDefaults.standard.set(sleepGoal, forKey: "goalSleep")

        // ✅ 요약 화면에 변경 사항 알림 전송
        NotificationCenter.default.post(name: Notification.Name("GoalUpdated"), object: nil)

        // ✅ 현재 화면 닫기
        self.dismiss(animated: true, completion: nil)
    }
}

