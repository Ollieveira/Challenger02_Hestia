//import Foundation
//import Speech
//import AVFoundation
//
//class SpeechToText: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
//    private enum RecognizerError: Error {
//        case nilRecognizer
//        case notAuthorizedToRecognize
//        case notPermittedToRecord
//        case recognizerIsUnavailable
//        
//        var message: String {
//            switch self {
//            case .nilRecognizer: return "Can't initialize speech recognizer"
//            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
//            case .notPermittedToRecord: return "Not permitted to record audio"
//            case .recognizerIsUnavailable: return "Recognizer is unavailable"
//            }
//        }
//    }
//    
//    var language: String
//    @Published private(set) var words: [String] = []
//    @Published private(set) var currentWord: String = ""
//    @Published var isSpeaking: Bool = false
//
//    private var audioEngine: AVAudioEngine?
//    private var request: SFSpeechAudioBufferRecognitionRequest?
//    private var task: SFSpeechRecognitionTask?
//    private let recognizer: SFSpeechRecognizer?
//    private let synthesizer = AVSpeechSynthesizer()
//    
//    func configureAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .duckOthers])
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("Failed to configure audio session: \(error.localizedDescription)")
//        }
//    }
//    
//    init(language: String) {
//        self.language = language
//        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: language))
//        super.init()
//        configureAudioSession()
//        synthesizer.delegate = self
//
//        Task {
//            do {
//                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
//                    throw RecognizerError.notAuthorizedToRecognize
//                }
//                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
//                    throw RecognizerError.notPermittedToRecord
//                }
//            } catch {
//                transcribe(error)
//            }
//        }
//    }
//    
//    func getIsPaused() -> Bool {
//        return synthesizer.isPaused
//    }
//    
//    func getIsSpeaking() -> Bool {
//        return synthesizer.isSpeaking
//    }
//    
//    func speak(text: String, language: String? = nil, rate: Float = 1.0) {
//        
////        for voice in AVSpeechSynthesisVoice.speechVoices() {
////            print("\(voice.name) - \(voice.identifier) - \(voice.quality)")
////        }
//
//        let utterance = AVSpeechUtterance(string: text)
//        
//        // Procurar a voz aprimorada de Luciana
//        if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.pt-BR.Luciana") {
//            utterance.voice = voice
//        }
//        
//        utterance.rate = rate
//        utterance.postUtteranceDelay = 1.0
//        synthesizer.speak(utterance)
//    }
//
//    func stopSpeaking() {
//        synthesizer.stopSpeaking(at: .immediate)
//    }
//    
//    func pauseSpeaking() {
//        if synthesizer.isSpeaking {
//            synthesizer.pauseSpeaking(at: .word)
//        }
//    }
//    
//    func continueSpeaking() {
//        if synthesizer.isPaused {
//            synthesizer.continueSpeaking()
//        }
//    }
//    
//    func startTranscribing() {
//        Task {
//            await transcribe()
//        }
//    }
//    
//    func resetTranscript() {
//        Task {
//            await reset()
//        }
//    }
//    
//    func stopTranscribing() {
//        Task {
//            await reset()
//        }
//    }
//    
//    private func transcribe() async {
//        guard let recognizer, recognizer.isAvailable else {
//            transcribe(RecognizerError.recognizerIsUnavailable)
//            return
//        }
//        
//        do {
//            let (audioEngine, request) = try Self.prepareEngine()
//            self.audioEngine = audioEngine
//            self.request = request
//            self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
//                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
//            }
//        } catch {
//            await reset()
//            transcribe(error)
//        }
//    }
//    
//    private func reset() async {
//        task?.cancel()
//        audioEngine?.stop()
//        audioEngine = nil
//        request = nil
//        task = nil
//        try? await Task.sleep(nanoseconds: 500_000_000) // Pausa de 0.5 segundo
//    }
//
//    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
//        let audioEngine = AVAudioEngine()
//        let request = SFSpeechAudioBufferRecognitionRequest()
//        request.shouldReportPartialResults = true
//        
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer, _) in
//            request.append(buffer)
//        }
//        audioEngine.prepare()
//        try audioEngine.start()
//        
//        return (audioEngine, request)
//    }
//    
//    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
//        if let result = result {
//            transcribe(result.bestTranscription.formattedString)
//            if result.isFinal {
//                stopTranscribing()
//            }
//        }
//        
//        if error != nil {
//            stopTranscribing()
//        }
//    }
//    
//    private func transcribe(_ message: String) {
//        Task { @MainActor in
//            let word = extractLastWord(from: message.lowercased())
//            words.append(word)
//            currentWord = word
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.currentWord = ""
//            }
//        }
//    }
//    
//    private func transcribe(_ error: Error) {
//        print("Transcription error: \(error.localizedDescription)")
//    }
//    
//    private func extractLastWord(from inputString: String) -> String {
//        let words = inputString.components(separatedBy: .whitespaces)
//        return words.last ?? ""
//    }
//    
//    // MARK: - AVSpeechSynthesizerDelegate
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        isSpeaking = false
//    }
//    
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        isSpeaking = false
//    }
//}
//
//
//extension SFSpeechRecognizer {
//    static func hasAuthorizationToRecognize() async -> Bool {
//        await withCheckedContinuation { continuation in
//            requestAuthorization { status in
//                continuation.resume(returning: status == .authorized)
//            }
//        }
//    }
//}
//
//extension AVAudioSession {
//    func hasPermissionToRecord() async -> Bool {
//        await withCheckedContinuation { continuation in
//            AVAudioApplication.requestRecordPermission { authorized in
//                continuation.resume(returning: authorized)
//            }
//        }
//    }
//}

//import Foundation
//import Speech
//import AVFoundation
//
//class SpeechToText: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
//    private enum RecognizerError: Error {
//        case nilRecognizer
//        case notAuthorizedToRecognize
//        case notPermittedToRecord
//        case recognizerIsUnavailable
//        
//        var message: String {
//            switch self {
//            case .nilRecognizer: return "Can't initialize speech recognizer"
//            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
//            case .notPermittedToRecord: return "Not permitted to record audio"
//            case .recognizerIsUnavailable: return "Recognizer is unavailable"
//            }
//        }
//    }
//    
//    var language: String
//    @Published private(set) var words: [String] = []
//    @Published private(set) var currentWord: String = ""
//    @Published var isSpeaking: Bool = false
//
//    private var audioEngine: AVAudioEngine?
//    private var request: SFSpeechAudioBufferRecognitionRequest?
//    private var task: SFSpeechRecognitionTask?
//    private let recognizer: SFSpeechRecognizer?
//    private let synthesizer = AVSpeechSynthesizer()
//    
//    func configureAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay, .duckOthers])
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("Failed to configure audio session: \(error.localizedDescription)")
//        }
//    }
//    
//    init(language: String) {
//        self.language = language
//        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: language))
//        super.init()
//        configureAudioSession()
//        synthesizer.delegate = self
//
//        Task {
//            do {
//                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
//                    throw RecognizerError.notAuthorizedToRecognize
//                }
//                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
//                    throw RecognizerError.notPermittedToRecord
//                }
//            } catch {
//                transcribe(error)
//            }
//        }
//    }
//    
//    func getIsPaused() -> Bool {
//        return synthesizer.isPaused
//    }
//    
//    func getIsSpeaking() -> Bool {
//        return synthesizer.isSpeaking
//    }
//    
//    func speak(text: String, language: String? = nil, rate: Float = 1.0) {
//        let utterance = AVSpeechUtterance(string: text)
//        
//        if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.pt-BR.Luciana") {
//            utterance.voice = voice
//        }
//        
//        utterance.rate = rate
//        utterance.postUtteranceDelay = 1.0
//        synthesizer.speak(utterance)
//    }
//
//    func stopSpeaking() {
//        synthesizer.stopSpeaking(at: .immediate)
//    }
//    
//    func pauseSpeaking() {
//        if synthesizer.isSpeaking {
//            synthesizer.pauseSpeaking(at: .word)
//        }
//    }
//    
//    func continueSpeaking() {
//        if synthesizer.isPaused {
//            synthesizer.continueSpeaking()
//        }
//    }
//    
//    func startTranscribing() {
//        Task {
//            await transcribe()
//        }
//    }
//    
//    func resetTranscript() {
//        Task {
//            await reset()
//        }
//    }
//    
//    func stopTranscribing() {
//        Task {
//            await reset()
//        }
//    }
//    
//    private func transcribe() async {
//        guard let recognizer, recognizer.isAvailable else {
//            transcribe(RecognizerError.recognizerIsUnavailable)
//            return
//        }
//        
//        do {
//            let (audioEngine, request) = try Self.prepareEngine()
//            self.audioEngine = audioEngine
//            self.request = request
//            self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
//                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
//            }
//        } catch {
//            await reset()
//            transcribe(error)
//        }
//    }
//    
//    private func reset() async {
//        task?.cancel()
//        audioEngine?.stop()
//        audioEngine = nil
//        request = nil
//        task = nil
//        try? await Task.sleep(nanoseconds: 500_000_000) // Pausa de 0.5 segundo
//    }
//
//    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
//        let audioEngine = AVAudioEngine()
//        let request = SFSpeechAudioBufferRecognitionRequest()
//        request.shouldReportPartialResults = true
//        
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//            request.append(buffer)
//        }
//        audioEngine.prepare()
//        try audioEngine.start()
//        
//        return (audioEngine, request)
//    }
//    
//    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
//        if let result = result {
//            transcribe(result.bestTranscription.formattedString)
//            if result.isFinal {
//                stopTranscribing()
//            }
//        }
//        
//        if let error = error {
//            transcribe(error.localizedDescription)
//            stopTranscribing()
//        }
//    }
//    
//    private func transcribe(_ message: String) {
//        Task { @MainActor in
//            let word = extractLastWord(from: message.lowercased())
//            words.append(word)
//            currentWord = word
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.currentWord = ""
//            }
//        }
//    }
//    
//    private func transcribe(_ error: Error) {
//        print("Transcription error: \(error.localizedDescription)")
//    }
//    
//    private func extractLastWord(from inputString: String) -> String {
//        let words = inputString.components(separatedBy: .whitespaces)
//        return words.last ?? ""
//    }
//    
//    // MARK: - AVSpeechSynthesizerDelegate
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        isSpeaking = false
//    }
//    
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        isSpeaking = false
//    }
//}
//
//
//extension SFSpeechRecognizer {
//    static func hasAuthorizationToRecognize() async -> Bool {
//        await withCheckedContinuation { continuation in
//            requestAuthorization { status in
//                continuation.resume(returning: status == .authorized)
//            }
//        }
//    }
//}
//
//extension AVAudioSession {
//    func hasPermissionToRecord() async -> Bool {
//        await withCheckedContinuation { continuation in
//            self.requestRecordPermission { authorized in
//                continuation.resume(returning: authorized)
//            }
//        }
//    }
//}

import Foundation
import Speech
import AVFoundation

class SpeechToText: ObservableObject {
    private enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    var language: String
    @Published private(set) var words: [String] = []
    @Published private(set) var currentWord: String = ""
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    private let synthesizer = AVSpeechSynthesizer()
    
    // Funcao que configura o reconhecimento de voz
    func configureAudioSessionForRecording() {
        print("Estou gravando!!")
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session for recording: \(error.localizedDescription)")
        }
    }
    
    // Funcao que configura o audio de leitura
    func configureAudioSessionForPlayback() {
        print("Estou falando!!")
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay, .duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session for playback: \(error.localizedDescription)")
        }
    }
    
    init(language: String) {
        self.language = language
        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: language))
        
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }
    
    func getIsPaused() -> Bool {
        return synthesizer.isPaused
    }
    
    func getIsSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
    
    func speak(text: String, language: String? = nil, rate: Float = 1.0) {
        configureAudioSessionForPlayback() // Configure the session for playback
        
        let utterance = AVSpeechUtterance(string: text)
        
        if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.pt-BR.Luciana") {
            utterance.voice = voice
        }
        
        utterance.rate = rate
        utterance.postUtteranceDelay = 1.0
        
        stopTranscribing() // Stop transcribing while speaking
        synthesizer.speak(utterance)
        
        let estimatedDuration = estimateSpeechDuration(text: text, rate: rate)
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedDuration) { [weak self] in
            self?.startTranscribing() // Restart transcribing after speaking
            self?.configureAudioSessionForRecording() // Configure the session for recording
        }
    }
    
    private func estimateSpeechDuration(text: String, rate: Float) -> TimeInterval {
        let wordsPerMinute = 250 * rate
        let wordCount = text.split(separator: " ").count
        return TimeInterval(wordCount) / Double(wordsPerMinute) * 60.0
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func pauseSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
        }
    }
    
    func continueSpeaking() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        }
    }
    
    func startTranscribing() {
        configureAudioSessionForRecording() // Ensure the session is configured for recording
        Task {
            await transcribe()
        }
    }
    
    func resetTranscript() {
        Task {
            await reset()
        }
    }
    
    func stopTranscribing() {
        Task {
            await reset()
        }
    }
    
    private func transcribe() async {
        guard let recognizer, recognizer.isAvailable else {
            transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            }
        } catch {
            await reset()
            transcribe(error)
        }
    }
    
    private func reset() async {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
        try? await Task.sleep(nanoseconds: 500_000_000) // Pausa de 0.5 segundo
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer, _) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        if let result = result {
            transcribe(result.bestTranscription.formattedString)
            if result.isFinal {
                stopTranscribing()
            }
        }
        
        if error != nil {
            stopTranscribing()
        }
    }
    
    private func transcribe(_ message: String) {
        Task { @MainActor in
            let word = extractLastWord(from: message.lowercased())
            words.append(word)
            currentWord = word
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentWord = ""
            }
        }
    }
    
    private func transcribe(_ error: Error) {
        print("Transcription error: \(error.localizedDescription)")
    }
    
    private func extractLastWord(from inputString: String) -> String {
        let words = inputString.components(separatedBy: .whitespaces)
        return words.last ?? ""
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
