import UIKit
import AVFoundation
import Monri

// MARK: - Photo Capture Delegate Protocol
protocol PhotoCaptureDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage)
    func didValidatePhoto(_ image: UIImage)
    func didCancelPhotoCapture()
}

// MARK: - Photo Capture View Controller
final class PhotoCaptureViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: PhotoCaptureDelegate?
    
    private let cameraManager = CameraManager()
    private let photoValidator = PhotoValidator()
    
    let scanDocApi = ScanDocApi(options: ScanDocApiOptions(scanDocApiBaseUrl: "https://monri-scandoc.asseco-see.hr/", userKey: "XCbnR54PAHma8hyBiP7J93xgzAHzAI", subClient: "ios_sdk_monri", acceptTermsAndConditions: true))
    
    private var capturedImage: UIImage?
    
    // MARK: - UI Components
    private lazy var cameraPreviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoPreviewView: PhotoPreviewView = {
        let view = PhotoPreviewView()
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            cameraManager.startSession()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraManager.updatePreviewLayerFrame(cameraPreviewView.bounds)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopSession()
        hidePhotoPreview()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(cameraPreviewView)
        view.addSubview(captureButton)
        view.addSubview(photoPreviewView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Camera Preview
            cameraPreviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraPreviewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            // Capture Button
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Photo Preview
            photoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            photoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCamera() {
        cameraManager.delegate = self
        cameraManager.setupCamera(in: cameraPreviewView)
    }
    
    // MARK: - Actions
    @objc private func captureButtonTapped() {
        cameraManager.capturePhoto()
    }
    
    // MARK: - Private Methods
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.showPermissionDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert()
        @unknown default:
            showPermissionDeniedAlert()
        }
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please allow camera access in Settings to take photos.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString),
               UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.delegate?.didCancelPhotoCapture()
        })
        
        present(alert, animated: true)
    }
    private func showPhotoPreview(with image: UIImage) {
        let resized = image.resizedMaintainingAspectRatio(maxDimension: 1024)
        
        capturedImage = resized
        photoPreviewView.configure(with: image)
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve) {
            self.cameraPreviewView.isHidden = true
            self.captureButton.isHidden = true
            self.photoPreviewView.isHidden = false
        }
    }
    
    private func hidePhotoPreview() {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve) {
            self.cameraPreviewView.isHidden = false
            self.captureButton.isHidden = false
            self.photoPreviewView.isHidden = true
        }
        
        capturedImage = nil
    }
}

extension UIImage {
    func resizedMaintainingAspectRatio(maxDimension: CGFloat) -> UIImage {
        let aspectRatio = size.width / size.height

        let targetSize: CGSize
        if aspectRatio > 1 {
            targetSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            targetSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

// MARK: - Camera Manager Delegate
extension PhotoCaptureViewController: CameraManagerDelegate {
    func didCapturePhoto(_ image: UIImage) {
        DispatchQueue.main.async {
            self.delegate?.didCapturePhoto(image)
            self.showPhotoPreview(with: image)
        }
    }
    
    func didFailToCapture(with error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Capture Failed",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Photo Preview Delegate
extension PhotoCaptureViewController: PhotoPreviewViewDelegate {
    func didTapRetakePhoto() {
        hidePhotoPreview()
    }
    
    func didTapSendForValidation() {
        guard let image = capturedImage else { return }
        
        scanDocApi.extractDataFromScannedCard(scannedCardImage: image) { resultOfExtraction in
            switch resultOfExtraction {
            case .success(let cardData):
                
                let vc = ExtractedDataViewController(data: cardData)
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
                self.alert("Extraction failed: \(failure)", didFail: true)
            }
        }
        
    }
    
    func alert(_ message: String, didFail: Bool) {
        let alert = UIAlertController(
            title: "Info",
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if didFail {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }

        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Photo Preview View
final class PhotoPreviewView: UIView {
    
    // MARK: - Delegate
    weak var delegate: PhotoPreviewViewDelegate?
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this image clear?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retake", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send for Validation", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        
        addSubview(imageView)
        addSubview(questionLabel)
        addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(retakeButton)
        buttonStackView.addArrangedSubview(sendButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -30),
            
            // Question Label
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            
            // Button Stack View
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    // MARK: - Actions
    @objc private func retakeButtonTapped() {
        delegate?.didTapRetakePhoto()
    }
    
    @objc private func sendButtonTapped() {
        delegate?.didTapSendForValidation()
    }
}

// MARK: - Photo Preview View Delegate
protocol PhotoPreviewViewDelegate: AnyObject {
    func didTapRetakePhoto()
    func didTapSendForValidation()
}

// MARK: - Camera Manager
final class CameraManager: NSObject {
    
    // MARK: - Properties
    weak var delegate: CameraManagerDelegate?
    
    private let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func enableTorch(on device: AVCaptureDevice) {
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 0.3) // avoid glare
            device.unlockForConfiguration()
        } catch {
            print("Torch failed:", error)
        }
    }
    
    // MARK: - Public Methods
    func setupCamera(in view: UIView) {
        guard let camera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
            delegate?.didFailToCapture(with: CameraError.noCameraAvailable)
            return
        }
        
        
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            try camera.lockForConfiguration()
            
            // Enable continuous autofocus
            if camera.isFocusModeSupported(.continuousAutoFocus) {
                camera.focusMode = .continuousAutoFocus
            }
            
            camera.unlockForConfiguration()
            
            session.beginConfiguration()
            
            // Remove existing inputs and outputs
            session.inputs.forEach { session.removeInput($0) }
            session.outputs.forEach { session.removeOutput($0) }
            
            // Configure session preset
            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }
            
            if session.canAddInput(input) && session.canAddOutput(photoOutput) {
                session.addInput(input)
                session.addOutput(photoOutput)
                
                session.commitConfiguration()
                setupPreviewLayer(in: view)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.session.startRunning()
                }
            } else {
                session.commitConfiguration()
                delegate?.didFailToCapture(with: CameraError.failedToSetupCamera)
            }
        } catch {
            session.commitConfiguration()
            delegate?.didFailToCapture(with: error)
        }
    }
    
    func updatePreviewLayerFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            self.previewLayer?.frame = frame
        }
    }
    
    func startSession() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Private Methods
    private func setupPreviewLayer(in view: UIView) {
        DispatchQueue.main.async {
            self.previewLayer?.removeFromSuperlayer()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }
    }
}

// MARK: - Camera Manager Delegate
protocol CameraManagerDelegate: AnyObject {
    func didCapturePhoto(_ image: UIImage)
    func didFailToCapture(with error: Error)
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.didFailToCapture(with: error)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            delegate?.didFailToCapture(with: CameraError.failedToProcessImage)
            return
        }
        
        delegate?.didCapturePhoto(image)
    }
}

// MARK: - Photo Validator
final class PhotoValidator {
    
    // MARK: - Public Methods
    func validatePhoto(_ image: UIImage, completion: @escaping (ValidationResult) -> Void) {
        // Simulate validation process
        DispatchQueue.global(qos: .userInitiated).async {
            // Add your validation logic here
            // This could include image quality checks, blur detection, etc.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success("Photo validated successfully"))
            }
        }
    }
}

// MARK: - Supporting Types
enum CameraError: LocalizedError {
    case noCameraAvailable
    case failedToProcessImage
    case failedToSetupCamera
    
    var errorDescription: String? {
        switch self {
        case .noCameraAvailable:
            return "No camera available on this device"
        case .failedToProcessImage:
            return "Failed to process captured image"
        case .failedToSetupCamera:
            return "Failed to setup camera"
        }
    }
}

enum ValidationResult {
    case success(String)
    case failure(String)
}
