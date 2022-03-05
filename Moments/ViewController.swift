//
//  ViewController.swift
//  Moments
//
//  Created by Ukejee on 1/3/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var moments = [Moment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Moments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMoment))
        
        let defaults = UserDefaults.standard
        
        if let savedMoments = defaults.object(forKey: "moments") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                moments = try jsonDecoder.decode([Moment].self, from: savedMoments)
            } catch {
                print("Failed to load moments")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Moment", for: indexPath) as? MomentCell else {
            fatalError("Failed to dequeue MomentCell.")
        }
        
        let moment = moments[indexPath.row]
        
        cell.name.text = moment.caption
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(moment.image)
        cell.momentImage.image = UIImage(contentsOfFile: imagePath.path)
        
        cell.momentImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.momentImage.layer.borderWidth = 2
        cell.momentImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Moment") as? MomentViewController {
            // 2: success! Set its selected image property
            vc.selectedMoment = moments[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func addMoment() {
        let imagePicker  = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let moment = Moment(caption: "", image: imageName)
        moments.append(moment)
        tableView.reloadData()
        save()
        
        dismiss(animated: true)
        
        if let position = moments.firstIndex(of: moment) {
            addCaption(position: position)
        } else {
            print("Can't find moment")
        }
    }
    
    func addCaption(position: Int) {
        let moment =  moments[position]
        let captionAc = UIAlertController(title: "Add Caption", message: "Tell us more about this moment", preferredStyle: .alert)
        captionAc.addTextField()
        captionAc.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak captionAc] _ in
            guard let newCaption = captionAc?.textFields?[0].text else { return }
            moment.caption = newCaption
            
            self?.tableView.reloadData()
            self?.save()
        })
        
        present(captionAc, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(moments) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "moments")
        }
    }

}

