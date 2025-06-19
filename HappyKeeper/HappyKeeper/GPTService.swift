import Foundation

class GPTService {
    static let shared = GPTService()

    // 실제 API 키는 보안상 plist 또는 .xcconfig로 분리 권장
    private let apiKey = "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" // 여기에 실제 유효한 키 입력

    func requestDiagnosis(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(NSError(domain: "GPTService", code: 1001, userInfo: [
                NSLocalizedDescriptionKey: "잘못된 URL입니다."
            ])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // ✅ GPT-4 요청 구성
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(NSError(domain: "GPTService", code: 1002, userInfo: [
                NSLocalizedDescriptionKey: "요청 데이터 생성에 실패했습니다."
            ])))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "GPTService", code: 1003, userInfo: [
                    NSLocalizedDescriptionKey: "유효하지 않은 서버 응답입니다."
                ])))
                return
            }

            guard httpResponse.statusCode == 200 else {
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = data,
                   let errorJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("❌ 서버 오류 응답:", errorJson)
                }
                completion(.failure(NSError(domain: "GPTService", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "서버 오류: \(httpResponse.statusCode) - \(errorMessage)"
                ])))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "GPTService", code: 1004, userInfo: [
                    NSLocalizedDescriptionKey: "응답 데이터가 없습니다."
                ])))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    // ✅ 말투 부드럽게 다듬기
                    let polished = self.polishResponse(content)
                    completion(.success(polished))
                } else {
                    completion(.failure(NSError(domain: "GPTService", code: 1005, userInfo: [
                        NSLocalizedDescriptionKey: "GPT 응답 형식이 올바르지 않습니다."
                    ])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // ✅ GPT 응답을 친절한 말투로 다듬는 함수
    private func polishResponse(_ text: String) -> String {
        var result = text

        // 간단한 톤 조정 (더 정교한 자연어 후처리는 GPT로 가능)
        result = result.replacingOccurrences(of: "권장됩니다", with: "추천드려요")
        result = result.replacingOccurrences(of: "필요합니다", with: "하는 것이 좋아요")
        result = result.replacingOccurrences(of: "주의해야 합니다", with: "주의하시면 좋겠습니다")
        result = result.replacingOccurrences(of: "필요할 수 있습니다", with: "도움이 될 수 있어요")
        result = result.replacingOccurrences(of: "조언드립니다", with: "도움이 되었으면 좋겠습니다 😊")

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

