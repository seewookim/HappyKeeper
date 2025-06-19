import Foundation

class GPTRateLimiter {
    static let shared = GPTRateLimiter()
    private var lastRequestTime: Date?

    func requestWithDelay(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let delay: TimeInterval = 10.0
        let now = Date()

        if let last = lastRequestTime, now.timeIntervalSince(last) < delay {
            let wait = delay - now.timeIntervalSince(last)
            DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
                self.send(prompt: prompt, completion: completion)
            }
        } else {
            send(prompt: prompt, completion: completion)
        }
    }

    private func send(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        lastRequestTime = Date()
        GPTService.shared.requestDiagnosis(prompt: prompt, completion: completion)
    }
}

