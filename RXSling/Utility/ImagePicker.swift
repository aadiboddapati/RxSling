//
//  ImagePicker.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 18/03/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]

    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            self!.pickerController.sourceType = type
            self?.pickerController.modalPresentationStyle = .overCurrentContext
            self!.presentationController?.present(self!.pickerController, animated: true,completion: {
                showBarButtonItem()
            })
        }
    }

    public func present(from sourceView: UIView) {
        showBarButtonItem()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take Photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera Roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }

        let cancelActionButton = UIAlertAction(title: "CANCEL", style: .default) { _ in
            //self.dismiss(animated: true, completion: nil)
            print("Cancel")
        }
        alertController.addAction(cancelActionButton)
//        alertController.addAction(UIAlertAction(title: LanguageManager.sharedInstance.LocalizedLanguage(key: "cancel"), style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = GREENCOLOUR
        alertController.view.tintColor = UIColor.black

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        hideBarBUttomItem()

    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hideBarBUttomItem()
        self.pickerController(picker, didSelect: nil)
        picker.dismiss(animated: true, completion: nil)
        pickerController.removeFromParent()
        pickerController.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }

        let resized = self.resizeImageTo1600(imageData: image.pngData()!)
        let resizedImage = UIImage(data: resized)
        self.delegate?.didSelect(image: resizedImage)
        self.pickerController(picker, didSelect: resizedImage)
        pickerController.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
        
       hideBarBUttomItem()
    }
    func resizeImageTo1600(imageData:Data)->Data{
        var resizedImage = UIImage(data: imageData)
        if(resizedImage!.size.height > 1600 || resizedImage!.size.width > 1600){
            resizedImage = resizedImage!.resizeImage(image: resizedImage!, targetSize: CGSize(width: 1599, height: 1599))
            return (resizedImage?.jpeg(.medium))!
        }else{
            return (resizedImage?.pngData())!
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
