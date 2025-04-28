import SwiftUI
import AVFoundation
import UIKit

struct ScanMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraModel = CameraViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // 全屏相机视图
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea()
            
            VStack {
                // 顶部导航栏
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        cameraModel.switchCamera()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // 底部指导文本和拍摄按钮
                VStack(spacing: 20) {
                    Text("Position the menu in the frame")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                    .padding(5)
                            )
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            cameraModel.checkPermission()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Camera Access"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: cameraModel.permissionDenied) { denied in
            if denied {
                alertMessage = "Please allow camera access in Settings to scan menus"
                showingAlert = true
            }
        }
    }
}

// 相机预览视图 - UIViewRepresentable包装AVCaptureSession
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.preview.frame = view.frame
        cameraModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.preview)
        
        // 启动相机会话
        cameraModel.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

// 相机视图模型 - 管理相机逻辑
class CameraViewModel: ObservableObject {
    @Published var permissionDenied = false
    @Published var capturedImage: UIImage?
    @Published var isFrontCamera = false
    
    var session = AVCaptureSession()
    var preview: AVCaptureVideoPreviewLayer!
    
    private var output = AVCapturePhotoOutput()
    private var currentCamera: AVCaptureDevice?
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                if status {
                    DispatchQueue.main.async {
                        self?.setupCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.permissionDenied = true
                    }
                }
            }
        default:
            permissionDenied = true
        }
    }
    
    func setupCamera() {
        do {
            session.beginConfiguration()
            
            // 默认使用后置摄像头
            let cameraPosition: AVCaptureDevice.Position = isFrontCamera ? .front : .back
            
            // 选择摄像头
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) {
                currentCamera = device
                let input = try AVCaptureDeviceInput(device: device)
                
                // 检查是否可以添加输入
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                // 检查是否可以添加输出
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
            }
            
            session.commitConfiguration()
        } catch {
            print("相机设置错误: \(error.localizedDescription)")
        }
    }
    
    func capturePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    
    func switchCamera() {
        isFrontCamera.toggle()
        
        // 重置会话
        session.beginConfiguration()
        
        // 删除旧的输入
        if let inputs = session.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                session.removeInput(input)
            }
        }
        
        // 重新配置相机
        setupCamera()
        
        session.commitConfiguration()
    }
}

// 扩展CameraViewModel以处理照片捕获
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("照片捕获错误: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("无法获取图像数据")
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            print("无法从数据创建图像")
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
            // 这里可以添加处理捕获的图像的代码
            // 例如：保存到相册、进行OCR识别菜单内容等
        }
    }
}

#Preview {
    ScanMenuView()
} 