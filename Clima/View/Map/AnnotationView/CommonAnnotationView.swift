//
//  CommonAnnotationView.swift
//  Clima
//
//  Created by Steven Zhang on 3/19/21.
//

import MapKit

class CommonAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var image: UIImage? {
        get { UIImage(systemName: "hello") }
        set { _ = newValue }
    }
    
    private func generateTextView(text: String) -> UIView  {
        let view = UIView()
        
        let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: 0)
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        return view
    }
}
