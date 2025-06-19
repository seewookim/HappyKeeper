import UIKit

class SignUpViewController: UIViewController {

    // MARK: - IBOutlet 연결
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()

        // 로고 이미지 설정
        logoImageView.image = UIImage(named: "app_logo") // Assets에 추가된 이미지
        logoImageView.contentMode = .scaleAspectFit
    }

    // MARK: - [1] 회원가입 완료 버튼 클릭
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showAlert(title: "입력 오류", message: "모든 항목을 입력해주세요.")
            return
        }

        guard password == confirmPassword else {
            showAlert(title: "비밀번호 불일치", message: "비밀번호가 일치하지 않습니다.")
            return
        }

        // ✅ 사용자 정보 저장
        UserDefaults.standard.set(email, forKey: "savedEmail")
        UserDefaults.standard.set(password, forKey: "savedPassword")

        // ✅ 저장 후 알림만 표시, 이동은 하지 않음
        showAlert(title: "회원가입 완료", message: "입력이 완료되었습니다.\n로그인 화면으로 이동 버튼을 눌러주세요.")
    }

    // MARK: - [2] 로그인 화면으로 이동 버튼 클릭
    @IBAction func backToLoginButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - 공통 알림창 함수
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

