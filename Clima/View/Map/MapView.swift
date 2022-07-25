//
//  MapView.swift
//  Clima
//
//  Created by Steven Zhang on 3/7/21.
//

import SwiftUI
import MapKit

struct MapViewPage: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @State var mapLayer: MapLayer = .none
    @State var annotationType: AnnotatinType = .none
    
    @State var showMapItems = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(mapLayer: $mapLayer, annotationType: $annotationType)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Menu {
                    ForEach(AnnotatinType.allCases) { type in
                        Button(action: { self.annotationType = type }) {
                            if annotationType == type {
                                Label(type.description, systemImage: "checkmark")
                            } else {
                                Label(type.description, systemImage: "checkmark")
                                    .labelStyle(.titleOnly)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "square.3.stack.3d.middle.fill")
                        .font(.title)
                }
                .padding([.top, .trailing])

                Spacer()
                Button(action: viewModel.backToCurrentLocation) {
                    Image(systemName: "location.circle.fill")
                        .font(.title)
                }
                .padding([.bottom, .trailing])
            }
        }
        .navigationBarTitle(Text("Map"), displayMode: .inline)
        .foregroundColor(AppSetting.shared.colorStyle.textColor)
    }
}

struct MapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @Binding var mapLayer: MapLayer
    @Binding var annotationType: AnnotatinType
    
    var allAnnotations: [MKAnnotation] = LoadCities.geneAnnotations()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(UVIAnnotation.self))
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(AirPollutionAnnotation.self))
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(WeatherAnnotation.self))
        
        // Add annotation based on current type
        if annotationType != .none {
            mapView.addAnnotations(allAnnotations)
        }
        
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let location = viewModel.region.coordinate {
            let cllCoordinate = location.cllCoordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: cllCoordinate, span: span)
            
            uiView.setRegion(region, animated: true)
        }
        
        if mapLayer != .none {
            let url = URLs.shared.mapLayerURL(layer: mapLayer)
            let overlay = MKTileOverlay(urlTemplate: url)
            overlay.canReplaceMapContent = false
            
            uiView.delegate = context.coordinator
            uiView.addOverlay(overlay, level: .aboveLabels)
        }
        
        if annotationType == .none {
            print("Tag: Anotation Removed")
            let annotations = uiView.annotations
            uiView.removeAnnotations(annotations)
        } else {
            // TODO: Change annotation type when annotationType is changed
            if uiView.annotations.isEmpty {
                uiView.addAnnotations(allAnnotations)
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        /// Update Map Layer
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKTileOverlay {
                let renderer = MKTileOverlayRenderer(overlay: overlay)
                return renderer
            } else {
                return MKTileOverlayRenderer()
            }
        }

        /// Map Annotation View
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch self.parent.annotationType {
            case .airpollution:
                if let annotation = annotation as? AirPollutionAnnotation {
                    return setUpAirpollutionAnnotationView(for: annotation, on: mapView)
                } else {
                    return nil
                }
            case .uvi:
                if let annotation = annotation as? UVIAnnotation {
                    return setUpUVIAnnotationView(for: annotation, on: mapView)
                } else {
                    return nil
                }
            case .weather:
                if let annotation = annotation as? WeatherAnnotation {
                    return setUpWeatherAnnotationView(for: annotation, on: mapView)
                } else {
                    return nil
                }
            case .none:
                return nil
            }
        }
        
        /// Map Annotation Add Animation
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            // Annotation presenting animation
            views.forEach{
                $0.alpha = 0
                $0.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping:0.4, initialSpringVelocity: 0, options: [], animations: {
                views.forEach {
                    $0.alpha = 1
                    $0.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }, completion: nil)
        }
        
        /// Remove or And Annotations When Map View Changed
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print("Tag: zoom level \(mapView.zoomLevel)")
            print("Tag: zoom level number \(mapView.annotations.count)")
            
            if mapView.zoomLevel <= 3.5 {
                mapView.removeAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .none))
                if mapView.zoomLevel <= 0.5 {
                    mapView.removeAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .minor))
                    if mapView.zoomLevel <= -1 {
                        mapView.removeAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .admin))
                    } else {
                        mapView.addAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .admin))
                    }
                } else {
                    mapView.addAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .minor))
                }
            } else {
                mapView.addAnnotations(filterUVIAnnotation(source: mapView.annotations, type: .none))
            }
            
            // TODO: Change Annotation Size When Zoom Level Changed
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
            
        }
        
        
        /// Filter Annotation For Adding/Removing Annotations
        private func filterUVIAnnotation(source: [MKAnnotation], type: Capital) -> [MKAnnotation] {
            var annotations: [MKAnnotation] = []
            for item in source {
                if let annotation = item as? UVIAnnotation {
                    if annotation.capital == type {
                        annotations.append(annotation)
                    }
                }
                if let annotation = item as? AirPollutionAnnotation {
                    if annotation.capital == type {
                        annotations.append(annotation)
                    }
                }
                if let annotation = item as? WeatherAnnotation {
                    if annotation.capital == type {
                        annotations.append(annotation)
                    }
                }
            }
            return annotations
        }
        
        private func setUpUVIAnnotationView(for annotation: UVIAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            let reuseIdentifier = NSStringFromClass(UVIAnnotation.self)
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
            
            view.canShowCallout = true
            let uvi = UVI(uvi: Int(annotation.uvi))
            view.backgroundColor = uvi.color
            
            let diameter = 15 * uvi.ratio
            view.frame.size = CGSize(width: diameter*2, height: diameter*2)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.layer.cornerRadius = diameter
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
            return view
        }
        
        private func setUpAirpollutionAnnotationView(for annotation: AirPollutionAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            let reuseIdentifier = NSStringFromClass(AirPollutionAnnotation.self)
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
            
            view.canShowCallout = true
            
            let aqi = AQI(rawValue: annotation.aqi)!
            let diameter = 15 * aqi.ratio
            
            view.backgroundColor = aqi.color
            
            view.frame.size = CGSize(width: diameter*2, height: diameter*2)
            view.layer.cornerRadius = diameter
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.detailCalloutAccessoryView = generateTextView(text: annotation.subtitle ?? "")
            
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 3
            
            return view
        }

        private func setUpWeatherAnnotationView(for annotation: WeatherAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            let reuseIdentifier = NSStringFromClass(WeatherAnnotation.self)
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
            
            view.canShowCallout = true
            let weather = WEATHER(main: annotation.main)
            let image = UIImage(systemName: ClimaUtils.iconToSystemIcon(icon: annotation.icon))?.filled(with: weather.color)
            view.image = image
            
            let addition_size = CGFloat.random(in: 0..<10)
            let diameter = 10 + addition_size
            view.frame.size = CGSize(width: diameter*2, height: diameter*2)
            
            return view
        }
        
        /// Set Up Annotation Accessory Text
        private func generateTextView(text: String) -> UIView  {
            let view = UIView()
            
            let label = UILabel()
            label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: 0)
            label.text = text
            label.numberOfLines = 0
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            return view
        }
    }
}

extension MKAnnotationView {
    /// Annotation Touch Animation
    private func setTouched(_ isTouched: Bool) {
        let scale = 0.8 + 0.06 * max(1, self.frame.width / 400)
        let transform = isTouched ? CGAffineTransform(scaleX: scale, y: scale) : .identity
        UIView.animate(withDuration: 0.2,
                       delay: 0.05,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .allowUserInteraction,
                       animations: {
            self.transform = transform
        })
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        setTouched(true)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        setTouched(false)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        setTouched(false)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewPage()
            .environmentObject(RegionWeatherViewModel())
    }
}


enum MapLayer: String, CaseIterable, Identifiable {
    case clouds_new
    case precipitation_new
    case pressure_new
    case wind_new
    case temp_new
    case none
    
    var description: String {
        switch self {
        case .clouds_new:
            return "Clouds"
        case .precipitation_new:
            return "Precipatation"
        case .pressure_new:
            return "Pressure"
        case .wind_new:
            return "Wind"
        case .temp_new:
            return "Temperature"
        case .none:
            return "None"
        }
    }
    
    var id: MapLayer {
        return self
    }
}

enum AnnotatinType: String, CaseIterable, Identifiable {
    case weather
    case uvi
    case airpollution
    case none
    
    var description: String {
        switch self {
        case .airpollution:
            return "Air Pollution"
        case .uvi:
            return "UVI"
        case .weather:
            return "Weather"
        case .none:
            return "None"
        }
    }
    
    var id: AnnotatinType {
        return self
    }
}


// MARK: - Annotation Test

class LoadCities {
    static func load() -> [City] {
        let filename = "cities"
        let data: Data
        
        do {
            guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
                print("Tag: not find cities")
                return []
            }
            
            data = try Data(contentsOf: file)
            
            do {
                return try JSONDecoder().decode([City].self, from: data)
            } catch {
                print("Tag: decode failed")
            }
        } catch {
            print("Tag: parse data failed")
        }
        
        return []
        
    }
    
    struct City: Codable {
        var lat: Double
        var lng: Double
        var city: String
        var capital: Capital
    }
    
    static func geneAnnotations() -> [MKAnnotation] {
        let cities = self.load()
        
        return cities.map {
            let uvi = Int.random(in: 0..<12)

            return UVIAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng), uvi: Double(uvi), capital: $0.capital)
            
//            let pm2_5 = 123.6
//            let pm10 = 78.6
//            let aqi = Int.random(in: 1...6)
//            return AirPollutionAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng), pm2_5: pm2_5, pm10: pm10, aqi: aqi, capital: $0.capital)
            
//            let weathers = [("Rain","10d"), ("Clear", "01d"), ("Clouds", "09d"), ("Snow", "50d"), ("Wind", "50d"), ("Thunderstorm", "11d")]
//            let weather_index = Int.random(in: 0..<weathers.count)
//
//            return WeatherAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng), main: weathers[weather_index].0, icon: weathers[weather_index].1, temp: 27.8, capital: $0.capital)
        }
    }
}
