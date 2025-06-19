import UIKit

class HealthInputViewController: UIViewController {

    // 🖼️ 이미지 및 UI 요소 연결
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var sleepTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 로고 이미지 설정
        logoImageView.image = UIImage(named: "app_logo")
        logoImageView.contentMode = .scaleAspectFit

        // 제목 라벨 설정
        titleLabel.text = "건강 정보 입력"
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center

        // 숫자 키보드 설정
        foodTextField.keyboardType = .numberPad
        activityTextField.keyboardType = .numberPad
        conditionTextField.keyboardType = .numberPad
        sleepTextField.keyboardType = .decimalPad
    }

    // 저장 버튼 클릭 시 실행
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let food = foodTextField.text ?? ""
        let activity = activityTextField.text ?? ""
        let condition = conditionTextField.text ?? ""
        let sleep = sleepTextField.text ?? ""

        // ✅ UserDefaults에 저장
        UserDefaults.standard.set(food, forKey: "inputFood")
        UserDefaults.standard.set(activity, forKey: "inputActivity")
        UserDefaults.standard.set(condition, forKey: "inputCondition")
        UserDefaults.standard.set(sleep, forKey: "inputSleep")

        // ✅ 디버깅용 출력
        print("✅ 저장 완료:")
        print("🍽️ 끼니 수: \(food)")
        print("🏃 운동 시간: \(activity)")
        print("🧠 피로도: \(condition)")
        print("😴 수면 시간: \(sleep)")

        // ✅ 건강 요약 화면으로 이동
        performSegue(withIdentifier: "toSummary", sender: self)
    }
}

