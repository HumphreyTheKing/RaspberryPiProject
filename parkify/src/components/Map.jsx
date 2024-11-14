import React, { useEffect, useRef } from 'react';
import { Loader2 } from 'lucide-react';

const Map = ({ garages, setLoading, loading }) => {
  const mapRef = useRef(null);
  const apiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;

  useEffect(() => {
    let scriptElement = null;

    const loadMap = async () => {
      try {
        const { Map } = await window.google.maps.importLibrary("maps");
        const { AdvancedMarkerElement } = await window.google.maps.importLibrary("marker");

        const position = { lat: 36.1077863, lng: -115.1453609 };
        
        // Check if map element exists
        if (!mapRef.current) {
          console.error('Map container not found');
          return;
        }

        const mapOptions = {
          zoom: 15.7,
          center: position,
          mapId: 'deb598f8aa025a7f',
          styles: [],
        };

        const newMap = new Map(mapRef.current, mapOptions);

        garages.forEach(garage => {
          try {
            new AdvancedMarkerElement({
              position: garage.position,
              map: newMap,
              title: garage.title,
            });
          } catch (error) {
            console.error('Error adding marker:', error);
          }
        });

        setLoading(false);
      } catch (error) {
        console.error('Error loading map:', error);
        setLoading(false);
      }
    };

    const initializeMap = () => {
      if (!window.google) {
        scriptElement = document.createElement("script");
        scriptElement.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap&libraries=maps,marker&v=beta`;
        scriptElement.async = true;
        scriptElement.defer = true;
        
        // Define the callback
        window.initMap = () => {
          loadMap();
        };

        document.head.appendChild(scriptElement);
      } else {
        loadMap();
      }
    };

    initializeMap();

    return () => {
      if (scriptElement) {
        document.head.removeChild(scriptElement);
      }
      // Clean up the callback
      delete window.initMap;
    };
  }, [garages, setLoading]);

  if (loading) {
    return (
      <div className="h-full w-full flex items-center justify-center bg-gray-100 rounded-lg">
        <Loader2 className="h-8 w-8 animate-spin text-gray-500" />
      </div>
    );
  }

  return (
    <div 
      ref={mapRef} 
      className="h-full w-full rounded-lg shadow-md"
      style={{ minHeight: '400px' }} 
    />
  );
};

export default Map;
