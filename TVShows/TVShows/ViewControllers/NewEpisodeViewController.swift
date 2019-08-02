//
//  NewEpisodeViewController.swift
//  TVShows
//
//  Created by Borna on 22/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

final class NewEpisodeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var seasonNumber: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
    
    // MARK: Properties
    var showID: String? = UserCredentials.shared.showId
    var token: String? = UserCredentials.shared.userToken
    weak var delegate: ResultSuccessDelagate?
    let imagePicker = UIImagePickerController()
    var mediaId: String?
  

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.setBackgroundImage(UIImage(named: "ic-camera"), for: .normal)
        
        setupNavigationBar()
       imagePicker.delegate = self
        
    }
    
    // MARK: Actions
    @IBAction func uploadPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        sender.highlightButton()
    }
    
    
    // MARK: Class methods
    private func setupNavigationBar() {
        
        navigationItem.title = "Add episode"
        
         let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel))
        
        let addButton = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow))
    
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        
        cancelButton.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        addButton.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
    }
    
    
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
        
    
    @objc func didSelectAddShow() {
        SVProgressHUD.show()
        
        guard let token = token else {return}
        let headers = ["Authorization": token]
        
        guard
            let title = episodeTitle.text,
            let description = episodeDescription.text,
            let episodeNumber =  episodeNumber.text,
            let seasonNumber = seasonNumber.text,
            let showID = showID
        else {
                print("text fields are empty")
                return
            }
        
            var parameters: [String: String] = [
                "showId": showID,
                "title": title,
                "description": description,
                "episodeNumber": episodeNumber,
                "season": seasonNumber
            ]
        
            if let mediaId = self.mediaId {
                parameters["mediaId"] = mediaId
            }
        
            Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
                    .validate()
                    .responseString {[weak self] (response:DataResponse<String>) in
                        switch response.result{
                        case .success:
                            SVProgressHUD.showSuccess(withStatus: "Success")
                            self?.dismiss(animated: true, completion: nil)
                            self?.delegate?.didAddEpisode()
                        case .failure(let error):
                            SVProgressHUD.showError(withStatus: "Failure")
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                SVProgressHUD.dismiss()
    }
    
}

protocol ResultSuccessDelagate: class {
    func didAddEpisode()
}

extension NewEpisodeViewController {

    func uploadImageOnAPI(token: String, image: UIImage) {
        let headers = ["Authorization": token]
        let imageByteData = image.pngData()!

        Alamofire
            .upload(multipartFormData: { multipartFormData in multipartFormData.append(imageByteData,
                                                                                       withName: "file",
                                                                                       fileName: "image.png",
                                                                                       mimeType: "image/png")},
                                        to: "https://api.infinum.academy/api/media",
                                        method: .post,
                                        headers: headers) { [weak self] result in
                                            switch result {
                                            case .success(let uploadRequest, _, _):
                                                self?.processUploadRequest(uploadRequest)
                                            case .failure(let encodingError):
                                                print(encodingError)
                                            }
            }
    }

    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    self.mediaId = media.mediaId
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
        }
    }
}

extension NewEpisodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) { [weak self] in
                // Careful about force unwrap
                self?.uploadImageOnAPI(token: UserCredentials.shared.userToken!, image: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
