//
//  MomentViewController.swift
//  Moments
//
//  Created by Ukejee on 1/3/22.
//

import UIKit

class MomentViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedMoment: Moment?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = selectedMoment?.caption
        
        if selectedMoment?.image != nil {
            let imagePath = getDocumentsDirectory().appendingPathComponent(selectedMoment!.image)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
