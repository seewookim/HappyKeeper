import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlet 연결
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!

    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()

        // 로고 이미지 설정 (Assets에 "app_logo" 있어야 함)
        logoImageView.image = UIImage(named: "app_logo")
        logoImageView.contentMode = .scaleAspectFit
    }

    // MARK: - 로그인 버튼 클릭
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let inputEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let inputPassword = passwordTextField.text ?? ""

        // 입력값 유효성 검사
        guard !inputEmail.isEmpty, !inputPassword.isEmpty else {
            showAlert(title: "입력 오류", message: "이메일과 비밀번호를 모두 입력해주세요.")
            return
        }

        // 저장된 사용자 정보 가져오기
        let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
        let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") ?? ""

        // 로그인 인증
        if inputEmail == savedEmail && inputPassword == savedPassword {
            print("✅ 로그인 성공")
            performSegue(withIdentifier: "toHealthInput", sender: self)
        } else {
            print("❌ 로그인 실패")
            showAlert(title: "로그인 실패", message: "이메일 또는 비밀번호가 잘못되었습니다.")
        }
    }

    // MARK: - 회원가입 화면 이동
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        print("📨 회원가입 화면으로 이동")
        performSegue(withIdentifier: "toSignUp", sender: self)
    }

    // MARK: - 알림창
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

