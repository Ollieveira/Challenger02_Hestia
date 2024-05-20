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
    @Published private(set) var words: [String]
    @Published private(set) var currentWord: String
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    private let synthesizer = AVSpeechSynthesizer()
    
    init(language: String,
         words: [String],
         currentWord: String,
         audioEngine: AVAudioEngine? = nil,
         request: SFSpeechAudioBufferRecognitionRequest? = nil,
         task: SFSpeechRecognitionTask? = nil,
         recognizer: SFSpeechRecognizer?) {
        self.language = language
        self.words = words
        self.currentWord = currentWord
        self.audioEngine = audioEngine
        self.request = request
        self.task = task
        self.recognizer = recognizer
    }
    
    convenience init(language: String) {
        self.init(language: language, words: [], currentWord: "", recognizer: SFSpeechRecognizer(locale: Locale(identifier: language)))
        guard recognizer != nil else { transcribe(RecognizerError.nilRecognizer); return }
        
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
    
//    var isSpeaking: Bool {
//        return synthesizer.isSpeaking
//    }
    
//    var isPaused: Bool {
//        return synthesizer.isPaused
    //    }
    //
    
    func getIsPaused() -> Bool {
        return synthesizer.isPaused
    }
    
    func getIsSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
    
// Metodo para ler um texto
    
    func speak(text: String, rate: Float = 1.0) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        
        // Defina a velocidade da leitura
        utterance.rate = rate
        utterance.postUtteranceDelay = 1.0

        
        synthesizer.speak(utterance)
    }

// Metodo para parar de ler o texto
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }

// Metodo para pausar a leitura
    
    func pauseSpeaking() {
            if synthesizer.isSpeaking {
                synthesizer.pauseSpeaking(at: .word)
            }
        }
    
// Metodo para retomar a leitura no momento que foi pausada
    
    func continueSpeaking() {
            if synthesizer.isPaused {
                synthesizer.continueSpeaking()
            }
        }

// Metodo para transformar fala em texto (reconhecimento de voz)
    
    func startTranscribing() {
        Task {
            await transcribe()
        }
    }

// Metodo que reseta o reconhecimento de voz
    
   func resetTranscript() {
        Task {
            await reset()
        }
    }

// Metodo que cancela o reconhecimento de voz
    
    func stopTranscribing() {
        Task {
            await reset()
        }
    }
    

    private func transcribe() async {
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
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
            await self.reset()
            self.transcribe(error)
        }
    }
    
    private func reset() async {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }
    
    
    private func transcribe(_ message: String) {
        Task { @MainActor in
            let word = extractLastWord(from: message.lowercased())
            words.append(word)
            currentWord = word
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.currentWord = ""
            }
        }
    }
    
    private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
    }
    
    func extractLastWord(from inputString: String) -> String {
        let words = inputString.components(separatedBy: .whitespaces)
        if let lastWord = words.last {
            return lastWord
        }
        return ""
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
