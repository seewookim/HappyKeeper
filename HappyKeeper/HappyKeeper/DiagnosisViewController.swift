import UIKit

class DiagnosisViewController: UIViewController {

    // ✅ UI 연결
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchAndAnalyzeHealthData()
    }

    /// 초기 UI 세팅
    private func setupUI() {
        logoImageView.image = UIImage(named: "app_logo")
        logoImageView.contentMode = .scaleAspectFit

        resultTitleLabel.text = "AI 건강 진단 결과"
        resultTextView.text = "🧠 AI가 오늘의 건강을 분석 중입니다...\n조금만 기다려주세요!"
        resultTextView.isEditable = false
        resultTextView.font = UIFont.systemFont(ofSize: 16)
    }

    /// UserDefaults에서 건강 정보 불러오고 GPT 분석 요청
    private func fetchAndAnalyzeHealthData() {
        let food = UserDefaults.standard.string(forKey: "inputFood") ?? "0"
        let activity = UserDefaults.standard.string(forKey: "inputActivity") ?? "0"
        let condition = UserDefaults.standard.string(forKey: "inputCondition") ?? "0"
        let sleep = UserDefaults.standard.string(forKey: "inputSleep") ?? "0"

        let prompt = """
        사용자의 오늘 건강 상태는 다음과 같습니다:
        🍽️ 끼니 수: \(food)회
        🏃 운동 시간: \(activity)분
        🧠 피로도: \(condition)/100
        🛌 수면 시간: \(sleep)시간

        위 데이터를 바탕으로 오늘 하루를 따뜻하고 고급스러운 말투로 요약해주시고,
        건강을 위한 간단한 조언을 한국어로 3~5줄 이내로 제공해주세요.
        """

        GPTRateLimiter.shared.requestWithDelay(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let analysis):
                    self.setFormattedText("💬 진단 결과\n\n\(analysis)")
                case .failure(let error):
                    self.setFormattedText("⚠️ 분석에 실패했어요.\n\n사유: \(error.localizedDescription)")
                    print("❌ GPT 오류:", error)
                }
            }
        }
    }

    /// 줄 간격을 적용한 텍스트 설정
    private func setFormattedText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]

        resultTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    /// 돌아가기 버튼 동작
    @IBAction func goBackButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
