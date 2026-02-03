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
    
    let scanDocApi = ScanDocApi(options: ScanDocApiOptions(scanDocApiBaseUrl: "REPLACE", userKey: "REPLACE", subClient: "REPLACE", acceptTermsAndConditions: true))
    
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

        blackNavigationBarAppearance()
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
        
        capturedImage = image
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
